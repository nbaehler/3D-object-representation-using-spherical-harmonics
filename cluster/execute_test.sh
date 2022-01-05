#!/bin/bash
#SBATCH --chdir /home/nbaehler/workspace/3D-object-representation-using-spherical-harmonics

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:5:0
#SBATCH --cpus-per-task=4
#SBATCH --partition=debug

# https://www.epfl.ch/research/facilities/scitas/hardware/fidis/
# https://www.epfl.ch/research/facilities/scitas/hardware/izar/

echo STARTING AT $(date)

. /home/nbaehler/workspace/3D-object-representation-using-spherical-harmonics/cluster/load.sh
python3 code/main.py

echo FINISHED at $(date)

#SBATCH --partition=gpu
#SBATCH --qos=gpu_free
#SBATCH --gres=gpu:1
