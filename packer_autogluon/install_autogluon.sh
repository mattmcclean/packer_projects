#!/bin/bash -ex

sudo apt-get update
sudo apt-get upgrade -y

conda create --yes -n autogluon_p37 python=3.7

source ~/anaconda3/etc/profile.d/conda.sh
conda activate autogluon_p37
pip install "mxnet_cu101<2.0.0"
pip install autogluon
pip install ray jupyter tensorboard

echo 'export PATH="$HOME/anaconda3/envs/autogluon_p37/bin:$PATH"' >> ~/.bashrc