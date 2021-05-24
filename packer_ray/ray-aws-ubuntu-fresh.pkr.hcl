packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "deep-learning-ray-ubuntu-{{timestamp}}"
  instance_type = "t3.xlarge"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = "Deep Learning AMI (Ubuntu 18.04) Version *"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["898082745236"]
  }
  ssh_username = "ubuntu"
  launch_block_device_mappings {
        device_name = "/dev/sda1"
        volume_size = "150"
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
      source = "conda_envs"
      destination = "/home/ubuntu"
  }  

  provisioner "shell" {
    scripts = [
      "setup_ami.sh"
    ]
#    pause_before = "600s"
  }
}