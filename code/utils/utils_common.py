import os
import logging
import pathlib

import numpy as np
import torch
from torch.autograd import Variable
import torch.nn.functional as F
from functools import reduce
import cv2
import time
import sys
from skimage import measure
from scipy.io import savemat

volume_suffix = ""


class DataModes:
    TRAINING = "training"
    TRAINING_EXTENDED = "training_concat"
    VALIDATION = "validation"
    TESTING = "testing"
    ALL = "all"

    def __init__(self):
        pass
        # dataset_splits = [DataModes.TRAINING, DataModes.TRAINING_EXTENDED,
        #                   DataModes.VALIDATION, DataModes.TESTING]


def write_lines(path, lines):
    with open(path, "w") as f:
        for line in lines:
            f.write(line + "\n")


def append_line(path, line):
    with open(path, "a") as f:
        f.write(line + "\n")


def pytorch_count_params(model):
    "count number trainable parameters in a pytorch model"
    return sum(reduce(lambda a, b: a * b, x.size()) for x in model.parameters())


def mkdir(path):
    if not os.path.isdir(path):
        pathlib.Path(path).mkdir(parents=True, exist_ok=True)


def blend(img, mask):

    img = cv2.cvtColor(np.uint8(img * 255), cv2.COLOR_GRAY2RGB)

    rows, cols, _ = img.shape
    pre_synaptic = np.zeros((rows, cols, 1))
    pre_synaptic[mask == 1] = 1

    synpase = np.zeros((rows, cols, 1))
    synpase[mask == 2] = 1

    post_synaptic = np.zeros((rows, cols, 1))
    post_synaptic[mask == 3] = 1

    color_mask = np.dstack((synpase, pre_synaptic, post_synaptic))
    color_mask = np.uint8(color_mask * 255)

    return cv2.addWeighted(img, 0.8, color_mask, 0.2, 0)


def crop_slices(shape1, shape2):
    return [
        slice((sh1 - sh2) // 2, (sh1 - sh2) // 2 + sh2)
        for sh1, sh2 in zip(shape1, shape2)
    ]


def crop_and_merge(tensor1, tensor2):

    slices = crop_slices(tensor1.size(), tensor2.size())
    slices[0] = slice(None)
    slices[1] = slice(None)
    slices = tuple(slices)

    return torch.cat((tensor1[slices], tensor2), 1)


def _box_in_bounds(box, image_shape):
    newbox = []
    pad_width = []

    for box_i, shape_i in zip(box, image_shape):
        pad_width_i = (max(0, -box_i[0]), max(0, box_i[1] - shape_i))
        newbox_i = (max(0, box_i[0]), min(shape_i, box_i[1]))

        newbox.append(newbox_i)
        pad_width.append(pad_width_i)

    needs_padding = any(i != (0, 0) for i in pad_width)

    return newbox, pad_width, needs_padding


def crop_indices(image_shape, patch_shape, center):
    box = [(i - ps // 2, i - ps // 2 + ps)
           for i, ps in zip(center, patch_shape)]
    box, pad_width, needs_padding = _box_in_bounds(box, image_shape)
    slices = tuple(slice(i[0], i[1]) for i in box)
    return slices, pad_width, needs_padding


def crop(image, patch_shape, center, mode="constant"):
    slices, pad_width, needs_padding = crop_indices(
        image.shape, patch_shape, center)
    patch = image[slices]

    if needs_padding and mode != "nopadding":
        if isinstance(image, np.ndarray):
            if len(pad_width) < patch.ndim:
                pad_width.append((0, 0))
            patch = np.pad(patch, pad_width, mode=mode)
        elif isinstance(image, torch.Tensor):
            assert len(pad_width) == patch.dim(), "not supported"
            # [int(element) for element in np.flip(np.array(pad_width).flatten())]
            patch = F.pad(
                patch,
                tuple(
                    int(element)
                    for element in np.flip(np.array(pad_width), axis=0).flatten()
                ),
                mode=mode,
            )

    return patch


def blend(img, labels, num_classes):
    colors = (
        torch.tensor([[0, 0, 0], [0, 255, 0], [255, 0, 0],
                      [0, 0, 255], [255, 0, 255]])
        .cuda()
        .float()
    )

    img = img[..., None].repeat(1, 1, 1, 3)
    masks = torch.zeros_like(img)
    for cls in range(1, num_classes):
        masks += (
            torch.ones_like(img) * colors[cls] *
            (labels == cls).float()[:, :, :, None]
        )

    return np.uint8((255 * img * 0.8 + masks * 0.2).data.cpu().numpy())


def blend_cpu(img, labels, num_classes):
    colors = torch.tensor(
        [[0, 0, 0], [0, 255, 0], [255, 0, 0], [0, 0, 255], [255, 0, 255]]
    ).float()

    img = img[..., None].repeat(1, 1, 1, 3)
    masks = torch.zeros_like(img)
    for cls in range(1, num_classes):
        masks += (
            torch.ones_like(img) * colors[cls] *
            (labels == cls).float()[:, :, :, None]
        )

    return np.uint8((255 * img * 0.8 + masks * 0.2).data.numpy())


def clean_border_pixels(image, step_size):
    """
    :param image:
    :param step_size:
    :return:
    """
    assert len(image.shape) == 3, "input should be 3 dim"

    D, H, W = image.shape
    y_ = image.clone()
    y_[:step_size] = 0
    y_[:, :step_size] = 0
    y_[:, :, :step_size] = 0
    y_[D - step_size:] = 0
    y_[:, H - step_size] = 0
    y_[:, :, W - step_size] = 0

    return y_


def normalize_vertices(vertices, shape):
    assert len(vertices.shape) == 2 and len(
        shape.shape) == 2, "Inputs must be 2 dim"
    assert shape.shape[0] == 1, "first dim of shape should be length 1"

    return 2 * (vertices / (torch.max(shape) - 1) - 0.5)


def voxel2mesh(volume, step_size, shape):
    """
    :param volume:
    :param step_size:
    :param shape:
    :return:
    """
    vertices_mc, faces_mc, _, _ = measure.marching_cubes(
        volume.cpu().data.numpy(), 0, step_size=step_size, allow_degenerate=False
    )
    vertices_mc = torch.flip(
        torch.from_numpy(vertices_mc), dims=[1]
    ).float()  # convert z,y,x -> x, y, z
    vertices_mc = normalize_vertices(vertices_mc, shape)
    faces_mc = torch.from_numpy(faces_mc).long()
    return vertices_mc, faces_mc


def save_to_obj(filepath, vertices, faces, normals=None):
    # write new data
    with open(filepath, "w") as file:
        vals = ""

        for vertice in vertices[0]:
            vertice = vertice.data.cpu().numpy()
            vals += "v " + " ".join(str(val) for val in vertice) + "\n"

        if normals is not None:
            for normal in normals[0]:
                normal = normal.data.cpu().numpy()
                vals += "vn " + " ".join(str(val) for val in normal) + "\n"

        if len(faces) > 0:
            for face in faces[0]:
                face = face.data.cpu().numpy()
                vals += "f " + " ".join(str(val + 1) for val in face) + "\n"

        file.write(vals)

        mat_path = os.path.splitext(filepath)[0] + ".mat"

    if normals is not None:
        savemat(
            mat_path,
            mdict={
                "vertices": vertices[0].data.cpu().numpy(),
                "faces": faces[0].data.cpu().numpy(),
                "normals": normals[0].data.cpu().numpy(),
            },
        )
    else:
        savemat(
            mat_path,
            mdict={
                "vertices": vertices[0].data.cpu().numpy(),
                "faces": faces[0].data.cpu().numpy(),
            },
        )


def sample_outer_surface_in_voxel(voxel):
    W, D, H = voxel.shape

    new_voxel = voxel.clone()

    for x in range(1, W - 1):
        for y in range(1, D - 1):
            for z in range(1, H - 1):
                if (
                    voxel[x][y][z] == 1
                    and voxel[x - 1][y][z] == 1
                    and voxel[x + 1][y][z] == 1
                    and voxel[x][y - 1][z] == 1
                    and voxel[x][y + 1][z] == 1
                    and voxel[x][y][z - 1] == 1
                    and voxel[x][y][z + 1] == 1
                ):

                    new_voxel[x][y][z] = 0

    return new_voxel
