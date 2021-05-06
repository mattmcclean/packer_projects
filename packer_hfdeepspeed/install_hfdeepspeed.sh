#!/bin/bash -ex

sudo apt-get update
sudo apt-get upgrade -y

conda create --yes -n hfdeepspeed_p37 python=3.7

source ~/anaconda3/etc/profile.d/conda.sh
conda activate hfdeepspeed_p37
pip install torch torchvision torchaudio
pip install ray[default]
pip install git+https://github.com/microsoft/DeepSpeed
pip install git+https://github.com/huggingface/transformers

echo 'export PATH="$HOME/anaconda3/envs/hfdeepspeed_p37/bin:$PATH"' >> ~/.bashrc