#!/bin/bash
virtualenv --system-site-packages ~/venvs/spharm
source ~/venvs/spharm/bin/activate
module load gcc/8.4.0 python/3.7.7

pip3 install --no-cache-dir ipython --user
pip3 install --no-cache-dir opencv-python --user
pip3 install --user --upgrade pillow
pip3 install --no-cache-dir scikit-image --user
pip3 install --no-cache-dir wandb --user

pip3 install --no-cache-dir nose --user
pip3 install --no-cache-dir pybind11 --user
# pip3 install --no-cache-dir pymesh2 --user
# pip3 install --no-cache-dir "git+https://github.com/PyMesh/PyMesh.git" --user
# module load cmake/3.16.5 eigen/3.3.7 boost/1.73.0
# git clone https://github.com/PyMesh/PyMesh.git
# cd PyMesh
# git submodule update --init
# cd third_party
# python build.py all
# cd ..
# mkdir build
# cd build
# cmake ..
# make
# make tests
# cd ..
# ./setup.py install --user
# python -c "import pymesh; pymesh.test()"
# cd ..
# rm -rf PyMesh

pip3 install --no-cache-dir autopep8 --user
pip3 install --no-cache-dir "git+https://github.com/facebookresearch/pytorch3d.git@stable" --user
pip3 install --no-cache-dir pydicom --user

deactivate
