#!/bin/bash -ex

sudo apt-get update
sudo apt-get upgrade -y

# install supervisor
sudo apt install supervisor -y

# remove the efa conf file with ulimit set too low
sudo rm /etc/security/limits.d/efa.conf

# Install Prometheus
echo "Installing Prometheus"
wget -qO $HOME/prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v2.27.0/prometheus-2.27.0.linux-amd64.tar.gz
sudo tar xvfz $HOME/prometheus.tar.gz -C /opt
sudo ln -s /opt/prometheus-2.27.0.linux-amd64 /opt/prometheus
rm $HOME/prometheus.tar.gz

# Install CloudWatch agent
echo "Installing CloudWatch agent"
wget -qO $HOME/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo apt install $HOME/amazon-cloudwatch-agent.deb
rm $HOME/amazon-cloudwatch-agent.deb
sudo apt-get install collectd -y
sudo usermod -aG adm cwagent

# activate to install conda envs
source ~/anaconda3/etc/profile.d/conda.sh

# install the conda envs
FILES="conda_envs/*.yaml"
for f in $FILES
do
    echo "Creating conda env with $f file..."
    conda env create -f $f
done

# setup inferentia environment
echo "Update the Inferentia env"
ENV_NAME=aws_neuron_pytorch_p36
source ~/anaconda3/etc/profile.d/conda.sh
conda activate ${ENV_NAME}
pip install -U ray ray[tune] ray[serve]
pip config set global.extra-index-url https://pip.repos.neuron.amazonaws.com
pip install -U --upgrade torch-neuron neuron-cc[tensorflow] torchvision
pip install -U "transformers==4.4.1"
pip install tensorboard

# setup tensorboard and mlflow
conda activate base
pip install mlflow
pip install tensorboardX tensorboard

# install the ipykernel in each env
for env in "pl_transformers_p37" "autogluon_p37" "pl-ray-mlflow"
do
    echo "Setting up ipykernel in env: $env"
    conda activate ${env}
    python -m ipykernel install --user --name=${env}
done