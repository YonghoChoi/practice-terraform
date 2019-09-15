#!/bin/sh

export VAR_FILE_DIR=../common/variable.tfvars
export PLAN_FILE_NAME=planfile

resources=(vpc security_group ec2)
for resource in "${resources[@]}"
do
  ./apply.sh $resource
  if [ "$?" -ne "0" ]; then
    echo "fail apply $resource"
    exit 1
  fi
done
