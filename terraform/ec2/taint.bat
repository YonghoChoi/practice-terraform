@echo off

terraform taint aws_instance.demo
if errorlevel 1 (
    pause
    goto :EOF
)

terraform taint aws_elb.demo
if errorlevel 1 (
    pause
    goto :EOF
)