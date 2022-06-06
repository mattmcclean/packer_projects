#!/bin/bash -ex

sudo apt-get update -y

# install neuron drivers
sudo apt --fix-broken install -y
sudo apt-get install linux-headers-$(uname -r) -y
sudo apt-get install aws-neuron-dkms --allow-change-held-packages -y
sudo apt-get install aws-neuron-tools -y

# install OCI add hooks
cd /tmp
wget -q https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
tar xzf go1.18.3.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
export PATH=$PATH:/usr/local/go/bin
rm /tmp/go1.18.3.linux-amd64.tar.gz

#go install github.com/joeshaw/json-lossless@latest
git clone https://github.com/awslabs/oci-add-hooks /tmp/oci-add-hooks
cd /tmp/oci-add-hooks
make build
sudo cp /tmp/oci-add-hooks/oci-add-hooks /usr/local/bin/

# restart docker
sudo cp /opt/aws/neuron/share/docker-daemon.json /etc/docker/daemon.json
sudo service docker restart

# install ECS agent
curl -O https://s3.eu-west-1.amazonaws.com/amazon-ecs-agent-eu-west-1/amazon-ecs-init-latest.amd64.deb
sudo dpkg -i amazon-ecs-init-latest.amd64.deb
sudo systemctl enable ecs
sudo systemctl stop ecs
sudo rm -rf /var/lib/ecs/data/*
