# Notes to build the AMI using Packer

1.  Install and initialise Packer (one time) by running the following commands:

```
brew tap hashicorp/tap
brew install hashicorp/tap/Packer
packer init .
```

2. Run Packer fmt and validate

```
    packer fmt .
    packer validate .
```

3. Run the Packer build command

```
    packer build autogluon-aws-ubuntu.pkr.hcl
```