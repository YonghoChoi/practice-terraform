@echo off

REM set TF_LOG=.\tf.log

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