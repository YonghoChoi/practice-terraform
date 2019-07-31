@echo off

set baseDir=%cd%
set securityGroupDir=%cd%\security_group
set ec2Dir=%cd%\ec2
set vpcDir=%cd%\vpc
set varFileDir=%cd%\common\variable.tfvars


for %%i in (%ec2Dir% %securityGroupDir% %vpcDir%) do (
    cd %%i
    terraform destroy -state="%%i\terraform.tfstate" -var-file="%varFileDir%" -force
)

cd %baseDir%