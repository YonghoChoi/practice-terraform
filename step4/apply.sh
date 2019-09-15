#!/bin/sh

terraform init

terraform plan -out=planfile

terraform apply "planfile"
