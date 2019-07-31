@echo off

set varFileDir=%cd%\common\variable.tfvars
set planFileName=planfile

for %%i in (vpc security_group ec2) do (
    .\apply.bat %%i
)