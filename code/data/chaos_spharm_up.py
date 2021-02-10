import numpy as np
from skimage import io
from data.data import get_item

from utils.metrics import jaccard_index, chamfer_weighted_symmetric, chamfer_directed
from utils.utils_common import crop, DataModes, crop_indices, blend, voxel2mesh, clean_border_pixels, save_to_obj

from torch.utils.data import Dataset
import torch
from sklearn.decomposition import PCA
import pickle
import torch.nn.functional as F
from numpy.linalg import norm
import itertools as itr
from scipy import ndimage
import os
import shutil
from IPython import embed
import pydicom
from statistics import mean

from pytorch3d.loss.chamfer import chamfer_distance


class PrepareSample:
    def __init__(self, x, y, name, step_size=None):
        self.x = x
        self.y = y
        self.name = name
        self.step_size = step_size


class Sample:
    def __init__(self, x, y, name, spharm_coeffs):
        self.x = x
        self.y = y
        self.name = name
        self.spharm_coeffs = spharm_coeffs


class SamplePlus:
    def __init__(self, x, y, name, spharm_coeffs, shape=None):
        self.x = x
        self.y = y
        self.name = name
        self.spharm_coeffs = spharm_coeffs
        # self.y_outer = y_outer
        # self.x_super_res = x_super_res
        # self.y_super_res = y_super_res
        self.shape = shape


class ChaosDataset():

    def __init__(self, data, cfg, mode):
        self.data = data
        # self.data = [data[0]] # <<<<<<<<<<<<<<<

        self.cfg = cfg
        self.mode = mode

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        item = self.data[idx]
        return get_item(item, self.mode, self.cfg)


class Chaos():

    def sample_to_sample_plus(self, samples, cfg, datamode):

        new_samples = []
        # surface_point_count = 100
        for sample in samples:

            x = sample.x
            y = sample.y

            y = (y > 0).long()

            center = tuple(d // 2 for d in x.shape)
            x = crop(x, cfg.patch_shape, center)
            y = crop(y, cfg.patch_shape, center)

            # shape = torch.tensor(y.shape)[None].float()
            # y_outer = sample_outer_surface_in_voxel(y)

            # x_super_res = torch.tensor(1)
            # y_super_res = torch.tensor(1)
            new_samples += [SamplePlus(x.cpu(), y.cpu(),
                                       sample.name, sample.spharm_coeffs)]

        return new_samples

    def pick_surface_points(self, y_outer, point_count):
        idxs = torch.nonzero(y_outer)
        perm = torch.randperm(len(idxs))

        y_outer = y_outer * 0
        idxs = idxs[perm[:point_count]]
        y_outer[idxs[:, 0], idxs[:, 1], idxs[:, 2]] = 1
        return y_outer

    def quick_load_data(self, cfg, trial_id):
        # assert cfg.patch_shape == (64, 256, 256), 'Not supported'
        down_sample_shape = cfg.patch_shape
        data = {}
        for datamode in [DataModes.TRAINING, DataModes.TESTING]:
            with open(cfg.runs_path + 'extended_data_{}_{}.pickle'.format(datamode, "_".join(map(str, down_sample_shape))), 'rb') as handle:
                samples = pickle.load(handle)
                new_samples = self.sample_to_sample_plus(
                    samples, cfg, datamode)
                data[datamode] = ChaosDataset(new_samples, cfg, datamode)
        data[DataModes.TRAINING_EXTENDED] = ChaosDataset(
            data[DataModes.TRAINING].data, cfg, DataModes.TRAINING_EXTENDED)
        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< switch to testing
        data[DataModes.VALIDATION] = data[DataModes.TESTING]
        return data

    def load_data(self, cfg):
        data_root = cfg.data_root
        samples = [dir for dir in os.listdir(data_root)]

        prepare_samples = []

        for sample in samples:
            if 'pickle' not in sample:
                print(sample)

                x = []
                images_path = [dir for dir in os.listdir(
                    '{}/{}/DICOM_anon'.format(data_root, sample)) if 'dcm' in dir]
                for image_path in images_path:
                    file = pydicom.dcmread(
                        '{}/{}/DICOM_anon/{}'.format(data_root, sample, image_path))
                    x += [file.pixel_array]

                d_resolution = file.SliceThickness
                h_resolution, w_resolution = file.PixelSpacing
                x = np.float32(np.array(x))

                # clip: x
                # CHAOS CHALLENGE: MedianCHAOS
                # Vladimir Groza from Median Technologies: CHAOS 1st place solution overview.
                # embed()
                # x[x<(1000-160)] = 1000-160
                # x[x>(1000+240)] = 1000+240
                # x = (x - x.min())/(x.max()-x.min())

                # io.imsave('/cvlabdata2/cvlab/datasets_udaranga/check1006.tif', np.uint8(x * 255))
                # x = io.imread('{}/{}/DICOM_anon/volume.tif'.format(data_root, sample))
                # x = np.float32(x)/2500
                # x[x>1] = 1
                #
                D, H, W = x.shape
                D = int(D * d_resolution)
                H = int(H * h_resolution)
                W = int(W * w_resolution)
                # we resample such that 1 pixel is 1 mm in x,y and z directions
                base_grid = torch.zeros((1, D, H, W, 3))
                w_points = (torch.linspace(-1, 1, W) if W >
                            1 else torch.Tensor([-1]))
                h_points = (torch.linspace(-1, 1, H) if H >
                            1 else torch.Tensor([-1])).unsqueeze(-1)
                d_points = (torch.linspace(-1, 1, D) if D >
                            1 else torch.Tensor([-1])).unsqueeze(-1).unsqueeze(-1)
                base_grid[:, :, :, :, 0] = w_points
                base_grid[:, :, :, :, 1] = h_points
                base_grid[:, :, :, :, 2] = d_points

                grid = base_grid.cuda()

                x = torch.from_numpy(x).cuda()
                x = F.grid_sample(
                    x[None, None], grid, mode='bilinear', padding_mode='border', align_corners=True)[0, 0]
                x = x.data.cpu().numpy()
                # ----

                x = np.float32(x)
                mean_x = np.mean(x)
                std_x = np.std(x)

                D, H, W = x.shape
                center_z, center_y, center_x = D // 2, H // 2, W // 2
                D, H, W = cfg.pad_shape
                x = crop(x, (D, H, W), (center_z, center_y, center_x))

                # io.imsave('{}/{}/DICOM_anon/volume_resampled_2.tif'.format(data_root, sample), np.uint16(x))

                x = (x - mean_x)/std_x
                x = torch.from_numpy(x)

                # ----

                y = []
                images_path = [dir for dir in os.listdir(
                    '{}/{}/Ground'.format(data_root, sample)) if 'png' in dir]
                for image_path in images_path:
                    file = io.imread(
                        '{}/{}/Ground/{}'.format(data_root, sample, image_path))
                    y += [file]

                y = np.array(y)
                y = np.int64(y)

                y = torch.from_numpy(y).cuda()
                y = F.grid_sample(y[None, None].float(), grid,
                                  mode='nearest', padding_mode='border', align_corners=True)[0, 0]
                y = y.data.cpu().numpy()

                y = np.int64(y)
                y = crop(y, (D, H, W), (center_z, center_y, center_x))

                y = torch.from_numpy(y/255)

                prepare_samples.append(PrepareSample(x, y, sample))

        if not os.path.exists(cfg.data_root):
            os.makedirs(cfg.data_root)

        with open(cfg.loaded_data_path, 'wb') as handle:
            pickle.dump(prepare_samples, handle,
                        protocol=pickle.HIGHEST_PROTOCOL)

    def prepare_data(self, cfg):
        if not os.path.exists(cfg.runs_path):
            os.makedirs(cfg.runs_path)

        with open(cfg.loaded_data_path, 'rb') as handle:
            samples = pickle.load(handle)

        working_samples = []

        # for step_size in range(1, 21):
        #     for s in samples:
        #         if not ((step_size == 18 and s.name == str(24)) or (s.name == str(29) and step_size == 19)):
        #             working_samples.append(PrepareSample(s.x, s.y, s.name + '_step_size_' + str(step_size), step_size))

        for step_size in cfg.known_to_work.keys():
            for s in samples:
                if int(s.name) in cfg.known_to_work[step_size]:
                    working_samples.append(PrepareSample(
                        s.x, s.y, s.name + '_step_size_' + str(step_size), step_size))

        np.random.seed(cfg.trial_id)
        perm = np.random.permutation(len(working_samples))
        tr_length = cfg.training_set_size
        counts = [perm[:tr_length], perm[tr_length:]]
        # counts = [perm[:tr_length], perm[16:]]

        down_sample_shape = cfg.patch_shape
        input_shape = working_samples[0].x.shape
        scale_factor = (np.max(down_sample_shape)/np.max(input_shape))

        for i, datamode in enumerate([DataModes.TRAINING, DataModes.TESTING]):
            print(datamode)
            print('--')

            new_samples = []

            for j in counts[i]:
                sample = working_samples[j]
                print(sample.name)

                sample.x = F.interpolate(
                    sample.x[None, None], scale_factor=scale_factor, mode='trilinear')[0, 0]
                sample.y = F.interpolate(sample.y[None, None].float(
                ), scale_factor=scale_factor, mode='nearest')[0, 0].long()

                new_samples.append(sample)

            with open(cfg.runs_path + 'prepared_data_{}_{}.pickle'.format(datamode, "_".join(map(str, down_sample_shape))), 'wb') as handle:
                pickle.dump(new_samples, handle,
                            protocol=pickle.HIGHEST_PROTOCOL)

            self.create_obj_files(cfg, new_samples, datamode)
        self.create_m_files(cfg)

    def create_obj_files(self, cfg, samples, datamode):
        save_path = cfg.runs_path+'label_meshes/'+datamode+'/'

        # Create folders for the output
        if not os.path.exists(save_path):
            os.makedirs(save_path)
        # Clear content if it already exists
        else:
            files = os.listdir(save_path)
            for file in files:
                os.remove(save_path+file)

        # Export to other formats
        print('There are ' + str(len(samples)) + ' files to proccess')
        for sample in samples:
            print('Process file ' + sample.name)

            # Voxel to mesh transformation
            y_ = clean_border_pixels(sample.y, step_size=sample.step_size)
            vertices, faces = voxel2mesh(
                y_, sample.step_size, torch.tensor(sample.y.shape)[None].float())

            # Save to obj file for meshlab
            # Points = V x 3
            # Points = 1 x V x 3
            # Faces =  1 x F x 3
            save_to_obj(save_path + 'label_' + sample.name +
                        '.obj', vertices[None], faces[None])

    def create_m_files(self, cfg):
        def addLine(outputStr, elem1, elem2, elem3):
            return outputStr + str(elem1) + ' ' + str(elem2) + ' ' + str(elem3) + '; ...\n'

        recDir = cfg.runs_path + 'reconstructions/'
        if not os.path.exists(recDir):
            os.makedirs(recDir)

        directory = cfg.runs_path + 'label_meshes'
        folders = os.listdir(directory)
        for folder in folders:
            subDir = directory + '/' + folder
            files = list(
                filter(lambda x: x.endswith('.obj'), os.listdir(subDir)))
            saveDir = cfg.runs_path + 'matlab_meshes/' + folder

            if not os.path.exists(saveDir):
                os.makedirs(saveDir)
            # Clear content if it already exists
            else:
                subFolders = os.listdir(saveDir)
                for subFolder in subFolders:
                    shutil.rmtree(saveDir+'/'+subFolder)

            print('There are ' + str(len(files)) +
                  ' files to convert for ' + folder)
            for i in range(len(files)):
                print('Convert file ' + str(i))
                baseName = os.path.splitext(os.path.basename(files[i]))[0]
                inputFileName = subDir + '/' + files[i]

                with open(inputFileName, 'r') as input:
                    outputContent = 'surface = struct(\'vertices\', ['

                    addFacesHeader = True
                    x = []
                    y = []
                    z = []
                    line = input.readline()
                    faceCount = 0

                    while line:
                        elems = line.split()

                        if (elems[0] == 'v'):
                            x.append(float(elems[1]))
                            y.append(float(elems[2]))
                            z.append(float(elems[3]))

                            outputContent = addLine(
                                outputContent, elems[1], elems[2], elems[3])

                        elif (elems[0] == 'f'):
                            if (addFacesHeader):
                                addFacesHeader = False
                                outputContent += '], \'faces\', ['

                            faceCount += 1
                            outputContent = addLine(
                                outputContent, elems[1], elems[2], elems[3])

                        line = input.readline()

                outputContent += '], \'landmarks\', ['

                i = x.index(min(x))
                outputContent = addLine(outputContent, x[i], y[i], z[i])

                i = x.index(max(x))
                outputContent = addLine(outputContent, x[i], y[i], z[i])

                i = y.index(min(y))
                outputContent = addLine(outputContent, x[i], y[i], z[i])

                i = y.index(max(y))
                outputContent = addLine(outputContent, x[i], y[i], z[i])

                i = z.index(min(z))
                outputContent = addLine(outputContent, x[i], y[i], z[i])

                i = z.index(max(z))
                outputContent = addLine(outputContent, x[i], y[i], z[i])

                outputContent = addLine(
                    outputContent, mean(x), mean(y), mean(z))

                outputContent += ']);\n'

                verticeCount = len(x)

                print('# vertices: ' + str(verticeCount) + ', # faces: ' +
                      str(faceCount) + ' (should have: ' + str(2*(verticeCount-2)) + ')')

                crtDir = saveDir + '/' + baseName
                if not os.path.exists(crtDir):
                    os.mkdir(crtDir)

                outputFileName = crtDir + '/' + baseName + '.m'

                with open(outputFileName, 'w') as output:
                    output.write(outputContent)

    def import_params(self, cfg):
        def load_spharm_coeffs_from_file(file_path):
            with open(file_path, 'r') as file:
                numbers = [word for line in file for word in line.split()]
                numbers.pop(0)

                return torch.FloatTensor(list(map(lambda number: float(number.rstrip('i')), numbers)))

        data = {}

        for datamode in [DataModes.TRAINING, DataModes.TESTING]:

            samples = []

            with open(cfg.runs_path + 'prepared_data_'+datamode+'.pickle', 'rb') as handle:
                prepare_samples = pickle.load(handle)

            print(datamode)
            print('--')

            for j in range(len(prepare_samples)):
                x = prepare_samples[j].x
                y = prepare_samples[j].y
                name = prepare_samples[j].name

                print(name)

                params_path = cfg.runs_path+'reconstructions/'+datamode+'/label_' + \
                    name+'/output_parameters_degree_' + \
                    str(cfg.spharm_degree)+'.txt'

                spharm_coeffs = load_spharm_coeffs_from_file(params_path)

                samples.append(Sample(x, y, name, spharm_coeffs))

            with open(cfg.runs_path + 'extended_data.pickle', 'wb') as handle:
                pickle.dump(samples, handle,
                            protocol=pickle.HIGHEST_PROTOCOL)

            data[datamode] = ChaosDataset(samples, cfg, datamode)
        print('-end-')
        data[DataModes.TRAINING_EXTENDED] = ChaosDataset(
            data[DataModes.TRAINING].data, cfg, DataModes.TRAINING_EXTENDED)
        data[DataModes.VALIDATION] = data[DataModes.TESTING]
        # raise Exception()
        return data

    def evaluate(self, target, pred, cfg):
        results = {}

        if target.voxel is not None:
            val_jaccard = jaccard_index(
                target.voxel, pred.voxel, cfg.num_classes)
            results['jaccard'] = val_jaccard[0]

            # inter, union = inter_and_union(target.voxel, pred.voxel)
            # results['jaccard'] = inter/union

        # if target.mesh is not None: TODO
        #     target_points = target.points
        #     pred_points = pred.mesh
        #     val_chamfer_weighted_symmetric = np.zeros(len(target_points))

        #     for i in range(len(target_points)):
        #         val_chamfer_weighted_symmetric[i] = chamfer_weighted_symmetric(target_points[i].cpu(), pred_points[i]['vertices'])

        #     results['chamfer_weighted_symmetric'] = val_chamfer_weighted_symmetric

        if target.points is not None:
            results['chamfer_weighted_symmetric'] = chamfer_distance(
                target.points, pred.points)[0].item()

        return results

    def update_checkpoint(self, best_so_far, new_value):

        key = 'jaccard'
        new_value = new_value[DataModes.TESTING][key]

        if best_so_far is None:
            return True
        best_so_far = best_so_far[DataModes.TESTING][key]
        return np.mean(new_value) > np.mean(best_so_far)
