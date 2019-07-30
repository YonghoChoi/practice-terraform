@echo off

terraform init
if errorlevel 1 (
    pause
    goto :EOF
)

terraform plan -out=planfile
if errorlevel 1 (
    pause
    goto :EOF
)

terraform apply "planfile"
if errorlevel 1 (
    pause
    goto :EOF
)