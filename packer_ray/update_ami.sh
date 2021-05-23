#!/bin/bash -ex

source ~/anaconda3/etc/profile.d/conda.sh

conda env remove -n pl-ray-mlflow
conda env create -f conda_envs/pl-ray-mlflow.yaml

#FILES="conda_envs/*.yaml"
#for f in $FILES
#do
#    echo "Creating conda env with $f file..."
#    conda env create -f $f
#done