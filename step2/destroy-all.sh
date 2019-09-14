#!/bin/sh

export VAR_FILE_DIR=../common/variable.tfvars

resources=(ec2 security_group vpc)
for resource in "${resources[@]}"
do
  ./destroy.sh $resource
done
