''' Dataset '''
# Command -> nvidia-smi
import os
GPU_index = "0" # 0, 1, 2, 3
os.environ["CUDA_VISIBLE_DEVICES"] = GPU_index

import logging
import torch
import numpy as np
from train import Trainer
from evaluate import Evaluator
# from data.chaos import Chaos
from data.chaos_spharm import Chaos
from shutil import copytree, ignore_patterns
import torch.optim as optim
from torch.utils.data import DataLoader
from utils.utils_common import DataModes
import wandb
from IPython import embed 
from utils.utils_common import mkdir

from config import load_config




logger = logging.getLogger(__name__)

 
def init(cfg):

    save_path = cfg.save_path + cfg.save_dir_prefix + str(cfg.experiment_idx).zfill(3) + '/'
    
    mkdir(save_path) 
 
    if cfg.trial_id is None:
        cfg.trial_id = (len([dir for dir in os.listdir(save_path) if 'trial' in dir]) + 1)

    trial_id = cfg.trial_id
    trial_str = 'trial_' + str(trial_id)
    trial_save_path = save_path + trial_str
    cfg.data_path += trial_str + '/'

    if not os.path.isdir(trial_save_path):
        mkdir(trial_save_path) 
        copytree(os.getcwd(), trial_save_path + '/source_code', ignore=ignore_patterns('*.git','*.txt','*.tif', '*.pkl', '*.off', '*.so', '*.json','*.jsonl','*.log','*.patch','*.yaml','wandb','run-*'))
  
    seed = trial_id
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.backends.cudnn.enabled = True  # speeds up the computation 

    return trial_save_path, trial_id

def main():

    #from models.unet import UNet as network
    from models.spharmnet import SPHarmNet as network
    exp_id = 1

    # Initialize
    cfg = load_config(exp_id)
    trial_path, trial_id = init(cfg)
 
    print('Experiment ID: {}, Trial ID: {}'.format(cfg.experiment_idx, trial_id))
    
    data_obj = Chaos()

    if cfg.mode == 'load':
        data_obj.load_data(cfg)
        print('Successfully loaded the data, prepare the samples for SPHARM')
        print('==> Trial ID: '+str(trial_id))
    elif cfg.mode == 'prepare':
        data_obj.prepare_data(cfg)
        print('Successfully prepared the data, compute the SPHARM parameters')
        print('==> Trial ID: '+str(trial_id))
    elif cfg.mode == 'import_params':
        data_obj.import_params(cfg)
        print('Successfully imported the SPHARM parameters')
        print('==> Trial ID: '+str(trial_id))
    elif cfg.mode == 'train' or cfg.mode == 'pretrained' or cfg.mode == 'evaluate':
        print("Create network")
        classifier = network(cfg)
        classifier.cuda()

        if cfg.mode != 'evaluate':
            wandb.init(name='Experiment_{}/trial_{}'.format(cfg.experiment_idx, trial_id), project="spharm", dir='/home/nicolas/workspace/ba6/spharm-project/experiments/')

        print("Initialize optimizer")
        optimizer = optim.Adam(filter(lambda p: p.requires_grad, classifier.parameters()), lr=cfg.learning_rate)

        print("Load data") 
        data = data_obj.quick_load_data(cfg, trial_id)

        loader = DataLoader(data[DataModes.TRAINING_EXTENDED], batch_size=classifier.config.batch_size, shuffle=True)

        print("Trainset length: {}".format(loader.__len__()))

        print("Initialize evaluator")
        evaluator = Evaluator(classifier, optimizer, data, trial_path, cfg, data_obj)

        if cfg.mode == 'evaluate':
            evaluator.do_complete_evaluations(data_obj, cfg)
            print('Successfully evaluated the results')
            print('==> Trial ID: '+str(trial_id))
        else:
            print("Initialize trainer")
            trainer = Trainer(classifier, loader, optimizer, cfg.numb_of_itrs, cfg.eval_every, trial_path, evaluator)
        
            if cfg.mode == 'pretrained':
                print("Loading pretrained network")
                save_path = trial_path + '/best_performance/model.pth'
                checkpoint = torch.load(save_path)
                classifier.load_state_dict(checkpoint['model_state_dict'])
                optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
                epoch = checkpoint['epoch']
            else:
                epoch = 1

            trainer.train(start_iteration=epoch)
            evaluator.save_incomplete_evaluations()
            print('Successfully trained, evaluate the results')
            print('==> Trial ID: '+str(trial_id))
    
    else:
        print('Invalid mode!')

if __name__ == "__main__": 
    main()