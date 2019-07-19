@echo off

set iamRoleDir=%cd%\iam
set securityGroupDir=%cd%\security_group
set ec2Dir=%cd%\ec2
REM set s3Dir=%cd%\s3
set vpcDir=%cd%\vpc
set varFileDir=%cd%\common\variable.tfvars


for %%i in (%ec2Dir% %securityGroupDir% %iamRoleDir% %vpcDir%) do (
    cd %%i
    terraform destroy -state="%%i\terraform.tfstate" -var-file="%varFileDir%" -force
)