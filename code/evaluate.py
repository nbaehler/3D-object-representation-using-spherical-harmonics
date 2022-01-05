from utils.utils_common import DataModes, mkdir, blend, crop, crop_indices, blend_cpu, append_line, write_lines, save_to_obj
from torch.utils.data import DataLoader
import numpy as np
import torch
from skimage import io
import itertools
import torch.nn.functional as F
import os
import pickle
from scipy import ndimage
from IPython import embed
import wandb
# from utils import stns

import re
# from pymesh import load_mesh, save_mesh, form_mesh #TODO fail to install
from pytorch3d.ops import sample_points_from_meshes
from pytorch3d.structures import Meshes
from utils.evaluate_utils import prepare_run, run_rasterize
import shutil


class Evaluation:
    def __init__(self, iteration, data):
        self.iteration = iteration
        self.data = data


class DataSample:
    def __init__(self, x, y, name, y_hat_spharm_coeffs):
        self.x = x
        self.y = y
        self.name = name
        self.y_hat_spharm_coeffs = y_hat_spharm_coeffs


class Structure(object):

    def __init__(self, voxel=None, mesh=None, points=None, sdf=None, voxel_rasterized=None, mesh_complex=None):
        self.voxel = voxel
        self.voxel_rasterized = voxel_rasterized
        self.mesh = mesh
        self.mesh_complex = mesh_complex
        self.points = points
        self.sdf = sdf


def write_to_wandb(writer, epoch, split, performances, num_classes):
    log_vals = {}
    for key, _ in performances[split].items():
        log_vals[split + '_' + key +
                 '/mean'] = np.mean(performances[split][key])
        for i in range(1, num_classes):
            log_vals[split + '_' + key + '/class_' +
                     str(i)] = np.mean(performances[split][key][:, i - 1])
    try:
        wandb.log(log_vals)
    except Exception:
        print('')


class Evaluator(object):
    def __init__(self, net, optimizer, data, save_path, config, support):
        self.data = data
        self.net = net
        self.current_best = None
        self.save_path = save_path + '/best_performance'
        self.latest = save_path + '/latest'
        self.optimizer = optimizer
        self.config = config
        self.support = support
        self.count = 0
        self.evaluations = []

    def save_model(self, epoch):

        torch.save({
            'epoch': epoch,
            'model_state_dict': self.net.state_dict(),
            'optimizer_state_dict': self.optimizer.state_dict()
        }, self.save_path + '/model.pth')

    def evaluate(self, epoch, writer=None, backup_writer=None):
        # self.net = self.net.eval()
        # performances = {}
        # predictions = {}

        for split in [DataModes.TESTING]:
            dataloader = DataLoader(
                self.data[split], batch_size=1, shuffle=False)
            # performances[split], predictions[split] = self.evaluate_set(dataloader)
            dataSamples = self.evaluate_set(dataloader)
            self.evaluations.append(Evaluation(
                iteration=epoch, data=dataSamples))

            # write_to_wandb(writer, epoch, split, performances, self.config.num_classes)

        # if self.support.update_checkpoint(best_so_far=self.current_best, new_value=performances):

        #     mkdir(self.save_path)
        #     mkdir(self.save_path + '/points')
        #     mkdir(self.save_path + '/mesh')
        #     mkdir(self.save_path + '/voxels')

        #     self.save_model(epoch)
        #     self.save_results(predictions[DataModes.TESTING], epoch, performances[DataModes.TESTING], self.save_path, '/testing_')
        #     self.current_best = performances

        print('iteration '+str(epoch)+', state saved for evaluation')

    def predict(self, data, config):
        name = config.name
        if name == 'unet':
            y_hat = self.net(data)
            y_hat = torch.argmax(y_hat, dim=1).cpu()

            x = data['x']
            y = Structure(voxel=data['y_voxels'].cpu())
            y_hat = Structure(voxel=y_hat)

        elif name == 'spharmnet':

            pred = self.net(data)
            pred = pred.detach().cpu()
            x = data['x']

            true_meshes = []
            true_points = []
            true_voxels = []

            true_meshes += [{'vertices': data['vertices_mc'],
                             'faces': data['faces_mc'], 'normals':None}]
            true_points += [data['surface_points']]
            true_voxels += [data['y_voxels']]

            x = x.detach().data.cpu()
            # , voxel_rasterized=true_voxels)# TODO true mesh (dict) marching cube, voxel binary mask, points 1xNx3
            y = Structure(mesh=true_meshes, voxel=true_voxels,
                          points=true_points)

        x = (x - torch.min(x)) / (torch.max(x) - torch.min(x))
        return x, y, pred

    def evaluate_set(self, dataloader):
        # performance = {}
        # predictions = []

        dataSamples = []

        for data in dataloader:

            x, y, y_hat_spharm_coeffs = self.predict(data, self.config)
            dataSamples.append(DataSample(
                x=x, y=y, name=data['name'][0], y_hat_spharm_coeffs=y_hat_spharm_coeffs))

            # result = self.support.evaluate(y, y_hat, self.config)

            # predictions.append((x, y, y_hat))

            # for key, value in result.items():
            #     if key not in performance:
            #         performance[key] = []
            #     performance[key].append(result[key])

        # for key, value in performance.items():
        #     performance[key] = np.array(performance[key])
        # return performance, predictions
        return dataSamples

    def save_incomplete_evaluations(self):
        eval_str = 'evaluations'

        with open(self.config.runs_path + eval_str + '.pickle', 'wb') as handle:
            pickle.dump(self.evaluations, handle,
                        protocol=pickle.HIGHEST_PROTOCOL)

        save_path = self.config.runs_path+eval_str+'/'

        # Delete evaluations folder if it already exists
        if os.path.exists(save_path):
            shutil.rmtree(save_path, ignore_errors=True)

        # Create the folder
        os.makedirs(save_path)

        for eval_str in self.evaluations:
            save_path = self.config.runs_path + \
                eval_str+'/'+str(eval_str.iteration)+'/'

            # Create folders for the output
            os.makedirs(save_path)

            for data in eval_str.data:
                with open(save_path+data.name+'.txt', 'w') as f:
                    params = data.y_hat_spharm_coeffs[0]

                    for j in range(len(params)):
                        delimiter = '\n' if j % 6 == 5 else ' '
                        f.write(str(params[j].item())+delimiter)

    def do_complete_evaluations(self, data_obj, cfg):
        with open(self.config.runs_path + 'evaluations.pickle', 'rb') as handle:
            evaluations = pickle.load(handle)

        save_path = self.config.runs_path+'evaluations/'

        chamfer = open(save_path + 'chamfer_distance.dat', 'w')
        with open(save_path + 'intersection_over_union.dat', 'w') as IoU:
            for eval in evaluations:
                print('evaluation at iteration '+str(eval.iteration))
                dist = 0
                ratio = 0

                for data in eval.data:
                    current_path = save_path+'/'+str(eval.iteration)+'/'
                    files = os.listdir(current_path)
                    p = re.compile(data.name+r'(.*).STL')
                    mesh_file = [f for f in files if p.match(f)][0]

                    # For now only one in the list TODO
                    data.y.mesh = data.y.mesh[0]
                    data.y.points = data.y.points[0][0][0]
                    data.y.voxel = data.y.voxel[0][0].cpu()

                    mesh = load_mesh(current_path+mesh_file)

                    vertices = mesh.vertices.tolist()
                    faces = mesh.faces.tolist()
                    pred_meshes = {'vertices': vertices,
                                   'faces': faces, 'normals': None}

                    vertices = torch.Tensor([vertices])
                    faces = torch.Tensor([faces])

                    mesh = Meshes(vertices, faces)
                    pred_points = sample_points_from_meshes(
                        mesh, cfg.samples_for_chamfer)

                    vertices = vertices[0]
                    faces = faces[0]

                    grid_size = data.y.voxel.shape

                    v, f = prepare_run(vertices, faces, grid_size=grid_size)
                    # Need to keep this trick!
                    voxels = run_rasterize(v * 0, f, grid_size=grid_size)
                    voxels = run_rasterize(v, f, grid_size=grid_size)

                    pred_voxels = torch.from_numpy(voxels/255).int()

                    # , voxel_rasterized=pred_voxels) TODO
                    y_hat = Structure(mesh=pred_meshes,
                                      voxel=pred_voxels, points=pred_points)

                    results = data_obj.evaluate(data.y, y_hat, cfg)

                    # --- Plots TODO

                    import matplotlib.pyplot as plt
                    import numpy as np
                    fig = plt.figure()
                    ax = fig.gca(projection='3d')
                    ax.voxels(pred_voxels)

                    plt.savefig(current_path+data.name+'_voxel_pred.png')

                    plt.close(fig)

                    fig = plt.figure()
                    ax = fig.gca(projection='3d')
                    ax.voxels(data.y.voxel)

                    plt.savefig(current_path+data.name+'_voxel_gt.png')

                    plt.close(fig)

                    # --- Point clouds TODO

                    xs = [p[0].item() for p in pred_points[0]]
                    ys = [p[1].item() for p in pred_points[0]]
                    zs = [p[2].item() for p in pred_points[0]]

                    fig = plt.figure()
                    ax = fig.gca(projection='3d')
                    ax.scatter(xs, ys, zs)

                    plt.savefig(current_path+data.name+'_points_pred.png')

                    plt.close(fig)

                    xs = [p[0].item() for p in data.y.points[0]]
                    ys = [p[1].item() for p in data.y.points[0]]
                    zs = [p[2].item() for p in data.y.points[0]]

                    fig = plt.figure()
                    ax = fig.gca(projection='3d')
                    ax.scatter(xs, ys, zs)

                    plt.savefig(current_path+data.name+'_points_gt.png')

                    plt.close(fig)

                    # --- Meshes TODO

                    mesh = form_mesh(
                        np.array(pred_meshes['vertices']), np.array(pred_meshes['faces']))
                    save_mesh(current_path+data.name+'_mesh_pred.obj', mesh)

                    verts = [vert.tolist()
                             for vert in data.y.mesh['vertices'][0][0]]
                    fcs = [fc.tolist() for fc in data.y.mesh['faces'][0][0]]

                    mesh = form_mesh(np.array(verts), np.array(fcs))
                    save_mesh(current_path+data.name+'_mesh_gt.obj', mesh)

                    # ---

                    dist += results['chamfer_weighted_symmetric']
                    ratio += results['jaccard']

                chamfer.write(str(eval.iteration)+' ' +
                              str(dist/len(eval.data))+'\n')
                IoU.write(str(eval.iteration)+' ' +
                          str(ratio/len(eval.data))+'\n')

            chamfer.close()

    def save_results(self, predictions, epoch, performance, save_path, mode):

        xs = []
        ys_voxels = []
        # ys_points = []
        y_hats_voxels = []
        # y_hats_points = []
        # y_hats_meshes = []

        for i, data in enumerate(predictions):
            x, y, y_hat = data

            xs.append(x[0, 0])

            if y_hat.points is not None:
                for p, (true_points, pred_points) in enumerate(zip(y.points, y_hat.points)):
                    save_to_obj(save_path + '/points/' + mode + 'true_' +
                                str(i) + '_part_' + str(p) + '.obj', true_points, [])
                    if pred_points.shape[1] > 0:
                        save_to_obj(save_path + '/points/' + mode + 'pred_' +
                                    str(i) + '_part_' + str(p) + '.obj', pred_points, [])

            if y_hat.mesh is not None:
                for p, (true_mesh, pred_mesh) in enumerate(zip(y.mesh, y_hat.mesh)):
                    save_to_obj(save_path + '/mesh/' + mode + 'true_' + str(i) + '_part_' + str(
                        p) + '.obj', true_mesh['vertices'], true_mesh['faces'], true_mesh['normals'])
                    save_to_obj(save_path + '/mesh/' + mode + 'pred_' + str(i) + '_part_' + str(
                        p) + '.obj', pred_mesh['vertices'], pred_mesh['faces'], pred_mesh['normals'])

            if y_hat.voxel is not None:
                ys_voxels.append(y.voxel[0])
                y_hats_voxels.append(y_hat.voxel[0])
                # io.imsave(save_path + '/voxels/x_'+str(i)+'.tif', np.uint8(255*x[0,0].data.cpu().numpy()))
                # io.imsave(save_path + '/voxels/y_'+str(i)+'.tif', np.uint8(y.voxel[0].data.cpu().numpy()))
                # io.imsave(save_path + '/voxels/y_hat_'+str(i)+'.tif', np.uint8(y_hat.voxel[0].data.cpu().numpy()))

        if performance is not None:
            for key, _ in performance.items():
                performance_mean = np.mean(performance[key], axis=0)
                summary = ('{}: ' + ', '.join(['{:.8f}' for _ in range(
                    self.config.num_classes-1)])).format(epoch, *performance_mean)
                append_line(save_path + mode + 'summary' +
                            key + '.txt', summary)
                print(summary)

                all_results = [
                    (
                        '{}: '
                        + ', '.join(
                            '{:.8f}' for _ in range(self.config.num_classes - 1)
                        )
                    ).format(*((i + 1,) + tuple(vals)))
                    for i, vals in enumerate(performance[key])
                ]

                write_lines(save_path + mode + 'all_results_' +
                            key + '.txt', all_results)

        xs = torch.cat(xs, dim=0).cpu()
        if y_hat.voxel is not None:
            ys_voxels = torch.cat(ys_voxels, dim=0).cpu()
            y_hats_voxels = torch.cat(y_hats_voxels, dim=0).cpu()

            y_hats_voxels = F.upsample(y_hats_voxels[None, None].float(), size=xs.shape)[
                0, 0].long()
            ys_voxels = F.upsample(ys_voxels[None, None].float(), size=xs.shape)[
                0, 0].long()

            y_overlap = y_hats_voxels.clone()
            y_overlap[ys_voxels == 1] = 3
            y_overlap[(ys_voxels == 1) & (y_hats_voxels == 1)] = 2

            overlay_y_hat = blend_cpu(
                xs, y_hats_voxels, self.config.num_classes)
            overlay_y = blend_cpu(xs, ys_voxels, self.config.num_classes)
            overlay_overlap = blend_cpu(xs, y_overlap, 4)
            overlay = np.concatenate(
                [overlay_y, overlay_y_hat, overlay_overlap], axis=2)
            io.imsave(save_path + mode + 'overlay_y_hat.tif', overlay)
