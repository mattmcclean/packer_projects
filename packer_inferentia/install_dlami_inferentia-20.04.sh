#!/bin/bash -ex

export DEBIAN_FRONTEND=noninteractive
/usr/bin/cloud-init status --wait

sudo apt-get update -y
sudo apt-get upgrade -y

# Install OS headers
sudo apt-get install linux-headers-$(uname -r) -y

. /etc/os-release
sudo tee /etc/apt/sources.list.d/neuron.list > /dev/null <<EOF
deb https://apt.repos.neuron.amazonaws.com ${VERSION_CODENAME} main
EOF
wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | sudo apt-key add -
sudo apt-get update -y

# Install Neuron Driver and tools
sudo apt-get install aws-neuron-dkms --allow-change-held-packages -y
sudo apt-get install aws-neuron-runtime-base -y
sudo apt-get install aws-neuron-tools -y
echo "export PATH=/opt/aws/neuron/bin:$PATH" >> ~/.bashrc

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