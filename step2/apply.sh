#!/bin/sh

if [ "$VAR_FILE_DIR" = "" ]; then
  VAR_FILE_DIR=../common/variable.tfvars
fi

if [ "$PLAN_FILE_NAME" = "" ]; then
  PLAN_FILE_NAME=planfile
fi

baseDir=$(pwd)
cd $baseDir/$1

echo "var file dir : $VAR_FILE_DIR"
terraform init -var-file=$VAR_FILE_DIR
if [ "$?" -ne "0" ]; then
  echo "fail plan"
  exit 1
fi

terraform plan -out=$PLAN_FILE_NAME -var-file=$VAR_FILE_DIR
if [ "$?" -ne "0" ]; then
  echo "fail plan"
  exit 1
fi

terraform apply "$PLAN_FILE_NAME"
if [ "$?" -ne "0" ]; then
  echo "fail apply"
  exit 1
fi

cd $baseDir