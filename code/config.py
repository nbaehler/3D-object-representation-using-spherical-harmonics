import numpy as np
import torch


class Config:
    def __init__(self):
        super(Config, self).__init__()


def load_config(exp_id):

    cfg = Config()
    """ Experiment """
    cfg.experiment_idx = exp_id

    # cfg.trial_id = None  # Use None for generating a new id
    cfg.trial_id = 1

    # Setup
    # cfg.mode = 'load'
    cfg.mode = "prepare"
    # cfg.mode = 'import_params'

    # Training
    # cfg.mode = 'train'
    # cfg.mode = 'pretrained'

    # Evaluate results
    # cfg.mode = 'evaluate'

    """ Save at """
    cfg.root_path = (
        "/home/nbaehler/workspace/3D-object-representation-using-spherical-harmonics/"
    )
    cfg.save_path = cfg.root_path + "experiments/"
    cfg.save_dir_prefix = "Experiment_"
    cfg.data_root = cfg.root_path + "data/Train_Sets/CT"
    cfg.runs_path = cfg.root_path + "runs/"
    cfg.loaded_data_path = cfg.root_path + "data/loaded_data.pickle"

    # sample names
    # [1,10,14,16,18,19,2,21,22,23,24,25,26,27,28,29,30,5,6,8] <- 20 in total

    # sample down down
    # degree 10, 10
    # cfg.known_to_work = {3:[16], 7:[23], 9:[14], 12:[1], 13:[10], 14:[19], 15:[2], 17:[18], 18:[8, 30]}
    # degree 8, 14
    cfg.known_to_work = {
        3: [8, 16, 25],
        4: [19, 24],
        5: [14],
        7: [23],
        8: [10],
        10: [22],
        12: [1],
        13: [18],
        14: [28],
        15: [2],
        18: [30],
    }

    # sample down up
    # degree 9, 4
    # cfg.known_to_work = {2:[1, 25], 3:[8, 30]}
    # degree 6, 10
    # cfg.known_to_work = {2:[1, 25], 3:[8, 30], 4:[6, 16, 18, 21, 24, 28]}
    # degree 4, 18
    # cfg.known_to_work = {2:[1, 25], 3:[8, 30], 4:[6, 16, 18, 21, 24, 28], 5:[2, 10, 14, 22, 23], 6:[19, 27, 29]}

    cfg.samples_for_chamfer = 10000

    # cfg.name = 'unet'
    cfg.name = "spharmnet"

    """ Dataset """
    cfg.training_set_size = 11
    cfg.pad_shape = (384, 384, 384)
    cfg.patch_shape = (64, 64, 64)
    cfg.ndims = 3
    cfg.augmentation_shift_range = 10

    """ Model """
    cfg.first_layer_channels = 32
    cfg.num_input_channels = 1
    cfg.steps = 5
    cfg.batch_size = 1
    cfg.num_classes = 2
    cfg.batch_norm = True

    """ SPHarm params"""
    cfg.spharm_degree = 8
    cfg.spharm_coefficient_count = 6 * (cfg.spharm_degree + 1) ** 2

    """ Optimizer """
    cfg.learning_rate = 1e-4

    """ Training """
    cfg.numb_of_itrs = 10000
    cfg.eval_every = 1000

    return cfg
