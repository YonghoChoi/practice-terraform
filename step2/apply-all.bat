@echo off

set varFileDir=%cd%\common\variable.tfvars
set planFileName=planfile

for %%i in (vpc security_group iam ec2) do (
    .\apply.bat %%i
)