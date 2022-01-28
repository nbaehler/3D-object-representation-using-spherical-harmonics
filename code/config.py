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
    # cfg.mode = 'load'  # TODO DON'T USE THIS LOCALLY! Needs more than 32 GiB of RAM
    cfg.mode = "prepare"  # TODO DON'T USE THIS LOCALLY! Needs more than 32 GiB of RAM
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
    # cfg.root_path = '/home/nicolas/workspace/own/spharm-project/' #TODO Path
    cfg.save_path = cfg.root_path + "experiments/"
    cfg.save_dir_prefix = "Experiment_"
    cfg.data_root = cfg.root_path + "data/Train_Sets/CT"
    cfg.runs_path = cfg.root_path + "runs/"
    cfg.loaded_data_path = cfg.root_path + "data/loaded_data.pickle"

    # sample names
    # [1,10,14,16,18,19,2,21,22,23,24,25,26,27,28,29,30,5,6,8] <- 20 in total

    # sample down down
    # min degree 8, 3-20 step size => 16 samples
    cfg.known_to_work = {
        1: 6,
        2: 15,
        5: 0,
        6: 3,
        8: 3,
        10: 5,
        14: 9,
        16: 3,
        18: 11,
        19: 4,
        21: 0,
        22: 10,
        23: 16,
        24: 4,
        25: 3,
        26: 11,
        27: 0,
        28: 14,
        29: 0,
        30: 12
    }

    cfg.samples_for_chamfer = 10000

    # cfg.name = 'unet'
    cfg.name = "spharmnet"

    """ Dataset """
    cfg.training_set_size = 12
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
