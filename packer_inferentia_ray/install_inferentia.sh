#!/bin/bash -ex

sudo apt-get update
sudo apt-get upgrade -y

source ~/anaconda3/etc/profile.d/conda.sh
conda activate aws_neuron_pytorch_p36
pip install -U ray ray[tune] ray[serve]
pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com
pip install -U --upgrade torch-neuron neuron-cc[tensorflow] torchvision
pip install -U "transformers==4.4.1"
pip install tensorboard

# remove to avoid ulimit issues
sudo rm /etc/security/limits.d/efa.conf

echo 'export PATH="$HOME/anaconda3/envs/aws_neuron_pytorch_p36/bin:$PATH"' >> ~/.bashrc