@echo off

set baseDir=%cd%
cd %baseDir%\%1

terraform init -var-file="..\common\variable.tfvars"
if errorlevel 1 (
    pause
    goto :EOF
)

terraform plan -out=planfile -var-file="..\common\variable.tfvars"
if errorlevel 1 (
    pause
    goto :EOF
)

terraform apply "planfile"
if errorlevel 1 (
    pause
    goto :EOF
)

cd %baseDir%