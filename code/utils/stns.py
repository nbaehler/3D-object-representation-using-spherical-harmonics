import torch.nn.functional as F
import torch
from utils import affine_3d_grid_generator
from IPython import embed
import time

import math


def stn_all_rotations_with_all_theta(angles, inverse=False):
    # 3,2
    angles_x, angles_y, angles_z = torch.chunk(angles, 3)

    theta_x = torch.eye(4)
    theta_y = torch.eye(4)
    theta_z = torch.eye(4)

    theta_x[1, 1:3] = angles_x * torch.FloatTensor([[1, -1]])
    theta_x[2, 1:3] = angles_x.index_select(1, torch.LongTensor([1, 0]))

    theta_y[0, 0:3:2] = angles_y
    theta_y[2, 0:3:2] = angles_y.index_select(
        1, torch.LongTensor([1, 0])
    ) * torch.FloatTensor([[-1, 1]])

    theta_z[0, 0:2] = angles_z * torch.FloatTensor([[1, -1]])
    theta_z[1, 0:2] = angles_z.index_select(1, torch.LongTensor([1, 0]))

    theta = theta_z @ theta_x @ theta_y if inverse else theta_y @ theta_x @ theta_z
    return theta, theta_x, theta_y, theta_z


def stn_all_rotations(params, inverse=False):
    theta, _, _, _ = stn_all_rotations_with_all_theta(params, inverse)
    return theta


# def stn_quaternion_rotations(params): #TODO old version

#     params = params.view(3)
#     qi, qj, qk = params

#     s = qi ** 2 + qj ** 2 + qk ** 2

#     theta = torch.eye(4, device=params.device)

#     theta[0, 0] = 1 - 2 * s * (qj ** 2 + qk ** 2)
#     theta[1, 1] = 1 - 2 * s * (qi ** 2 + qk ** 2)
#     theta[2, 2] = 1 - 2 * s * (qi ** 2 + qj ** 2)

#     theta[0, 1] = 2 * s * qi * qj
#     theta[0, 2] = 2 * s * qi * qk

#     theta[1, 0] = 2 * s * qi * qj
#     theta[1, 2] = 2 * s * qj * qk

#     theta[2, 0] = 2 * s * qi * qk
#     theta[2, 1] = 2 * s * qj * qk

#     return theta


def stn_quaternion_rotations(params):
    params = params.view(4)
    qr, qi, qj, qk = params

    s = 1 / (math.sqrt(qr ** 2 + qi ** 2 + qj ** 2 + qk ** 2) ** 2)

    theta = torch.eye(4, device=params.device)

    theta[0, 0] = 1 - 2 * s * (qj ** 2 + qk ** 2)
    theta[1, 1] = 1 - 2 * s * (qi ** 2 + qk ** 2)
    theta[2, 2] = 1 - 2 * s * (qi ** 2 + qj ** 2)

    theta[0, 1] = 2 * s * (qi * qj - qk * qr)
    theta[0, 2] = 2 * s * (qi * qk + qj * qr)

    theta[1, 0] = 2 * s * (qi * qj + qk * qr)
    theta[1, 2] = 2 * s * (qj * qk - qi * qr)

    theta[2, 0] = 2 * s * (qi * qk - qj * qr)
    theta[2, 1] = 2 * s * (qj * qk + qi * qr)

    return theta


def stn_batch_quaternion_rotations(params, inverse=False):
    thetas = []
    for param in params:
        theta = stn_quaternion_rotations(param)
        if inverse:  # TODO check that inversion
            theta = theta.inverse()
        thetas.append(theta)

    thetas = torch.cat(thetas, dim=0)
    thetas = thetas.view(-1, 4, 4)
    return thetas


def scale(param):
    theta_scale = torch.eye(4)

    theta_scale[0, 0] = param
    theta_scale[1, 1] = param
    theta_scale[2, 2] = param

    return theta_scale


def rotate(angles):
    angle_x, angle_y, angle_z = angles
    params = torch.Tensor(
        [
            torch.cos(angle_x),
            torch.sin(angle_x),
            torch.cos(angle_y),
            torch.sin(angle_y),
            torch.cos(angle_z),
            torch.sin(angle_z),
        ]
    )
    params = params.view(3, 2)
    return stn_all_rotations(params)


def mirror(axes):
    theta = torch.eye(4, device=axes.device)
    theta[0, 0] = axes[0]
    theta[1, 1] = axes[1]
    theta[2, 2] = axes[2]

    return theta


def shift(axes):
    theta = torch.eye(4, device=axes.device)
    theta[0, 3] = axes[0]
    theta[1, 3] = axes[1]
    theta[2, 3] = axes[2]

    return theta


def transform(theta, x, y=None, w=None, w2=None):
    theta = theta[0:3, :].view(-1, 3, 4)
    grid = affine_3d_grid_generator.affine_grid(
        theta,
        x[None].shape,
    )
    if x.device.type == "cuda":
        grid = grid.cuda()
    x = F.grid_sample(
        x[None], grid, mode="bilinear", padding_mode="zeros", align_corners=False
    )[0]
    if y is not None:
        y = F.grid_sample(
            y[None, None].float(),
            grid,
            mode="nearest",
            padding_mode="zeros",
            align_corners=False,
        ).long()[0, 0]
    else:
        return x
    if w is not None:
        w = F.grid_sample(
            w[None, None].float(),
            grid,
            mode="nearest",
            padding_mode="zeros",
            align_corners=False,
        ).long()[0, 0]
        return x, y, w
    else:
        return x, y
    # if w2 is not None:
    # w2 = F.grid_sample(w2[None, None].float(), grid, mode='nearest', padding_mode='zeros').long()[0, 0]


def quaternion_to_euler(q):
    # roll (x-axis rotation)
    sinr_cosp = 2 * (q[0] * q[1] + q[2] * q[3])
    cosr_cosp = 1 - 2 * (q[1] * q[1] + q[2] * q[2])
    roll = math.atan2(sinr_cosp, cosr_cosp)

    # pitch (y-axis rotation)
    sinp = 2 * (q[0] * q[2] - q[3] * q[1])
    pitch = math.copysign(
        math.pi / 2, sinp) if abs(sinp) >= 1 else math.asin(sinp)
    # yaw (z-axis rotation)
    siny_cosp = 2 * (q[0] * q[3] + q[1] * q[2])
    cosy_cosp = 1 - 2 * (q[2] * q[2] + q[3] * q[3])
    yaw = math.atan2(siny_cosp, cosy_cosp)

    return roll, pitch, yaw
