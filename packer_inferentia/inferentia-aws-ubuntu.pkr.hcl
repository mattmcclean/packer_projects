packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "deep-learning-inferentia-ubuntu-{{isotime \"2006-01-02T16_04_05\"}}"
  instance_type = "t3.2xlarge"
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
      "install_inferentia.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo systemctl enable apt-daily.timer",
      "sudo systemctl enable apt-daily-upgrade.timer",
    ]
  }
}