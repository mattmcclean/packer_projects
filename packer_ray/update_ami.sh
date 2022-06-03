#!/bin/bash -ex

#function wait-apt-get() { while fuser -s /var/lib/dpkg/lock; do echo 'apt-get is waiting for the lock release ...'; sleep 1; done; sudo /usr/bin/apt-get "$@"; }

#lsof /var/lib/dpkg/lock-frontend
#sudo pkill -9 pid
#sudo rm /var/lib/dpkg/lock-frontend
#sudo dpkg --configure -a

#wait-apt-get install jq -y

# activate to install conda envs
#source /home/ubuntu/anaconda3/etc/profile.d/conda.sh

# install the conda envs and ipykernel
#FILES="conda_envs/pl_trans*.yaml"
#for f in $FILES
#do
#    echo "Creating conda env with $f file..."
#    conda env create -f $f
#    env=$(basename "$f" .yaml)
#    echo "Setting up ipykernel in env: $env"
#    conda activate ${env}
#    python -m ipykernel install --user --name=${env}
#    conda deactivate    
#done

#conda activate autogluon_p37
#python -m pip install --upgrade ray
#conda deactivate
sudo apt-get install ec2-instance-connect -y