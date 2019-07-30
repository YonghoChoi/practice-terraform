@echo off

terraform destroy
if errorlevel 1 (
    pause
    goto :EOF
)