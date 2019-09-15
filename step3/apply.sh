#!/bin/sh

terraform get
if [ "$?" -ne "0" ]; then
  exit 1
fi

terraform init
if [ "$?" -ne "0" ]; then
  exit 1
fi

terraform plan -out=planfile
if [ "$?" -ne "0" ]; then
  exit 1
fi

terraform apply "planfile"
if [ "$?" -ne "0" ]; then
  exit 1
fi