#!/bin/bash -ex

sudo apt-get update
sudo apt-get upgrade -y

# install supervisor
sudo apt install supervisor -y

# Install the Conda environment
ENV_NAME=pl_transformers_p37
conda create --yes -n ${ENV_NAME} python=3.7
source ~/anaconda3/etc/profile.d/conda.sh
conda activate ${ENV_NAME}
pip install torch torchvision torchaudio
pip install pytorch-lightning  
pip install ray[default] ray[tune] ray[serve]
pip install boto3
pip install transformers
pip install ipykernel matplotlib ipywidgets
pip install tensorboardX
pip install webdataset
#pip install lightning-transformers["extra"]

# install a ipykernel in enviornment
python -m ipykernel install --user --name=${ENV_NAME}

# setup tensorboard and mlflow
conda activate base
pip install mlflow
pip install tensorboardX tensorboard

# remove the efa conf file with ulimit set too low
sudo rm /etc/security/limits.d/efa.conf

# Install Prometheus
echo "Installing Prometheus"
wget -qO $HOME/prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v2.27.0/prometheus-2.27.0.linux-amd64.tar.gz
sudo tar xvfz $HOME/prometheus.tar.gz -C /opt
sudo ln -s /opt/prometheus-2.27.0.linux-amd64 /opt/prometheus
rm $HOME/prometheus.tar.gz

echo 'export PATH="$HOME/anaconda3/envs/'${ENV_NAME}'/bin:$PATH"' >> ~/.bashrc