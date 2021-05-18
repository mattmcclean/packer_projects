packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "deep-learning-pl-transformers-ubuntu-{{isotime \"2006-01-02\"}}"
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
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    scripts = [
      "install_pl_transformers.sh"
    ]
    pause_before = "600s"
  }
}