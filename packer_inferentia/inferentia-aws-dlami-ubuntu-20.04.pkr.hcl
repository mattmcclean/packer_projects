packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "dlami-inferentia-ubuntu-20.04-amd64"
  instance_type = "t3.2xlarge"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = "Deep Learning AMI*PyTorch 1.11*Ubuntu 20*"
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
      "install_dlami_inferentia-20.04.sh"
    ]
  }

}