from utils.utils_common import DataModes, clean_border_pixels, voxel2mesh
from utils import stns

import torch
import torch.nn.functional as F

# from utils import stns
# from utils.utils_mesh import voxel2mesh, clean_border_pixels
import numpy as np
from IPython import embed

import torch
from pytorch3d.ops import sample_points_from_meshes
from pytorch3d.structures import Meshes

import cmath
from math import sin, cos, sqrt, pi, exp
from math import factorial as fact


class Sample:
    def __init__(self, x, y, spharm_coeffs):
        self.x = x
        self.y = y
        # self.atlas = atlas
        self.spharm_coeffs = spharm_coeffs


class SamplePlus:
    def __init__(self, x, y, spharm_coeffs, shape=None):
        self.x = x
        self.y = y
        self.spharm_coeffs = spharm_coeffs
        # self.y_outer = y_outer
        # self.x_super_res = x_super_res
        # self.y_super_res = y_super_res
        self.shape = shape


class DatasetAndSupport(object):
    def quick_load_data(self, patch_shape):
        raise NotImplementedError

    def load_data(self, patch_shape):
        raise NotImplementedError

    def evaluate(self, target, pred, cfg):
        raise NotImplementedError

    def save_results(self, target, pred, cfg):
        raise NotImplementedError

    def update_checkpoint(self, best_so_far, new_value):
        raise NotImplementedError


def get_item(item, mode, config):

    # for the first set of experiments item.y.... TODO switch to x
    x = item.y.float().cuda()[None]
    y = item.y.cuda()
    name = item.name
    spharm_coeffs = item.spharm_coeffs

    # augmentation done only during training TODO comment -> training loss will reduce
    if mode == DataModes.TRAINING_EXTENDED:  # if training do augmentation
        # if torch.rand(1)[0] > 0.5: #TODO changes the coefficients ?!!??!
        #     x = x.permute([0, 1, 3, 2])
        #     y = y.permute([0, 2, 1])

        # if torch.rand(1)[0] > 0.5:
        #     x = torch.flip(x, dims=[1])
        #     y = torch.flip(y, dims=[0])

        # if torch.rand(1)[0] > 0.5:
        #     x = torch.flip(x, dims=[2])
        #     y = torch.flip(y, dims=[1])

        # if torch.rand(1)[0] > 0.5:
        #     x = torch.flip(x, dims=[3])
        #     y = torch.flip(y, dims=[2])

        # orientation = torch.tensor([0, -1, 0]).float() #TODO only 3 quaternions
        # new_orientation = (torch.rand(3) - 0.5) * 2 * np.pi
        # new_orientation[2] = new_orientation[2] * 0 # no rotation outside x-y plane
        # new_orientation = F.normalize(new_orientation, dim=0)
        # q = orientation + new_orientation
        # q = F.normalize(q, dim=0)

        # Scaling
        # f = 0.1
        # scale = 1.0 - 2 * f * (torch.rand(1) - 0.5)

        # theta_scale = stns.scale(1/scale)

        # spharm_coeffs *= scale

        # # Shift
        # shift = torch.tensor([d / (D // 2) for d, D in zip(
        #     2 * (torch.rand(3) - 0.5) * config.augmentation_shift_range, y.shape)])

        # theta_shift = stns.shift(-shift)

        # spharm_coeffs[0] += shift[0]*sqrt(4*pi)
        # spharm_coeffs[2] += shift[1]*sqrt(4*pi)
        # spharm_coeffs[4] += shift[2]*sqrt(4*pi)

        # Rotation
        # orientation = torch.tensor([0, -1, 0, 0]).float()
        # new_orientation = (torch.rand(4) - 0.5) * 2 * np.pi
        # new_orientation = F.normalize(new_orientation, dim=0)
        # q = orientation + new_orientation
        # q = F.normalize(q, dim=0)

        # theta_rotate = stns.stn_quaternion_rotations(q)

        # roll, pitch, yaw = stns.quaternion_to_euler(q)
        # new_spharm_coeffs = []

        # first = 0
        # for l in range(0, config.spharm_degree+1):
        #     for m in range(-l, l+1):
        #         index = first

        #         new_coeffs = [complex(0)] * 3

        #         for n in range(-l, l+1):
        #             d = 0

        #             for t in range(max(0, n-m), min(l+n, l-m)+1):
        #                 denominator = fact(l+n-t)*fact(l-m-t)+fact(t+m-n)*fact(t)
        #                 d += ((-1)**t)/denominator*((cos(pitch)/2)**(2*l+n-m-2*t))

        #             numerator = sqrt(fact(l+n)*fact(l-n)*fact(l+m)*fact(l-m))
        #             factor = (sin(pitch)/2)**(2*l+m-n)
        #             d *= numerator*factor

        #             D = cmath.exp((-1j)*yaw*n)*d*cmath.exp((-1j)*roll*m)
        #             for dim in range(0, len(new_coeffs)):
        #                 new_coeffs[dim] += D*complex(spharm_coeffs[index], spharm_coeffs[index+1])
        #                 index += 2

        #         for dim in range(0, len(new_coeffs)):
        #             new_spharm_coeffs.append(new_coeffs[dim].real)
        #             new_spharm_coeffs.append(new_coeffs[dim].imag)

        #     first = index

        # theta = theta_rotate @ theta_shift @ theta_scale
        # theta = theta_shift @ theta_scale
        # theta = theta_scale
        # theta = theta_shift

        # ----------------------------------------------------------

        # import os
        # import pickle

        # save_path = config.data_path+'testing/'

        # # Create folders for the output
        # if not os.path.exists(save_path):
        #     os.makedirs(save_path)

        # with open(save_path + 'y_before.pickle', 'wb') as handle:
        #     pickle.dump(y, handle, protocol=pickle.HIGHEST_PROTOCOL)

        # ----------------------------------------------------------

        # x, y = stns.transform(theta, x, y)
        # spharm_coeffs = torch.Tensor(new_spharm_coeffs)

        # ----------------------------------------------------------

        # f = open(save_path+'coeffs.txt', 'w')

        # params = spharm_coeffs

        # for j in range(len(params)):
        #     delimiter = '\n' if j % 6 == 5 else ' '
        #     f.write(str(params[j].item())+delimiter)
        # f.close()

        # with open(save_path + 'x.pickle', 'wb') as handle:
        #     pickle.dump(x, handle, protocol=pickle.HIGHEST_PROTOCOL)

        # with open(save_path + 'y_after.pickle', 'wb') as handle:
        #     pickle.dump(y, handle, protocol=pickle.HIGHEST_PROTOCOL)

        # import sys
        # sys.exit()

        # ----------------------------------------------------------

        return {"name": name, "x": x, "y_voxels": y, "y_spharm_coeffs": spharm_coeffs}

    vertices_mc_all = []
    faces_mc_all = []
    for i in range(1, config.num_classes):
        shape = torch.tensor(y.shape)[None].float()
        if mode != DataModes.TRAINING_EXTENDED:
            step_size = 1
            y_ = clean_border_pixels((y == i).long(), step_size=step_size)
            vertices_mc, faces_mc = voxel2mesh(y_, step_size, shape)

            vertices_mc_all += [vertices_mc]
            faces_mc_all += [faces_mc]

    meshes = Meshes(vertices_mc_all, faces_mc_all)
    surface_points_all = [sample_points_from_meshes(meshes, config.samples_for_chamfer)]

    return {
        "name": name,
        "x": x,
        "y_voxels": y,
        "y_spharm_coeffs": spharm_coeffs,
        "vertices_mc": vertices_mc_all,
        "faces_mc": faces_mc_all,
        "surface_points": surface_points_all,
    }
