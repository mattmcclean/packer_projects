#!/bin/bash -ex

function wait-apt-get() { while fuser -s /var/lib/dpkg/lock; do echo 'apt-get is waiting for the lock release ...'; sleep 1; done; sudo /usr/bin/apt-get "$@"; }

#lsof /var/lib/dpkg/lock-frontend
#sudo pkill -9 pid
#sudo rm /var/lib/dpkg/lock-frontend
#sudo dpkg --configure -a

wait-apt-get install jq -y

#FILES="conda_envs/*.yaml"
#for f in $FILES
#do
#    echo "Creating conda env with $f file..."
#    conda env create -f $f
#done