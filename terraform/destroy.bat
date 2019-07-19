@echo off

set baseDir=%cd%
cd %baseDir%\%1

terraform destroy -var-file="..\common\variable.tfvars"
if errorlevel 1 (
    pause
    goto :EOF
)

cd %baseDir%