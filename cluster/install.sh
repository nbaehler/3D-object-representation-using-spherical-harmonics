#!/bin/bash
virtualenv --system-site-packages ~/venvs/spharm
source ~/venvs/ml/bin/activate
module load gcc/8.4.0 python/3.7.7 git/2.27.0 cmake/3.16.5

pip3 install --no-cache-dir ipython --user
pip3 install --no-cache-dir opencv-python --user
pip3 install --user --upgrade pillow
pip3 install --no-cache-dir scikit-image --user
pip3 install --no-cache-dir wandb --user
# pip3 install --no-cache-dir pymesh2 --user
# pip3 install --no-cache-dir "git+https://github.com/PyMesh/PyMesh.git" --user

# git clone https://github.com/PyMesh/PyMesh.git
# cd PyMesh
# git submodule update --init
# # mkdir build
# # cd build
# # cmake ..
# ./setup.py build
# ./setup.py install --user
# python -c "import pymesh; pymesh.test()"
# cd ..
# rm -rf PyMesh

pip3 install --no-cache-dir autopep8 --user
pip3 install --no-cache-dir "git+https://github.com/facebookresearch/pytorch3d.git@stable" --user
pip3 install --no-cache-dir pydicom --user
pip3 install --no-cache-dir pydicom --user

deactivate
