#!/bin/bash

if [ "$VAR_FILE_DIR" = "" ]; then
  VAR_FILE_DIR=../common/variable.tfvars
fi

baseDir=$(pwd)
cd $baseDir/$1

terraform destroy -var-file="$VAR_FILE_DIR" -force
if [ "$?" -ne "0" ]; then
  echo "fail destroy"
  exit 1
fi

cd $baseDir