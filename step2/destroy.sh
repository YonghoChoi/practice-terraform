#!/bin/bash
set baseDir=$(pwd)
cd $baseDir/$1

terraform destroy -var-file="../common/variable.tfvars" -force
if [ "$?" -ne "0" ]; then
  echo "fail destroy"
  exit 1
fi

cd $baseDir