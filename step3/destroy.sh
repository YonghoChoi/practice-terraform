#!/bin/sh

# kops destroy 실행을 위해 ec2를 먼저 제거
#   - destroy 시 remote-exec 실행과 동시에 IAM Role이 병행 제거 되기 때문에 kops가 리소스를 제거하려고 할 때 권한이 없어서 제거되지 않음
#   - resource의 경우 depends_on을 사용하여 kops 명령 실행 후 IAM Role을 제거하도록 할 수 있지만 현재 module에는 depends_on 미지원
terraform destroy -target module.ec2 -force
if [ "$?" -ne "0" ]; then
  exit 1
fi

terraform destroy -force
if [ "$?" -ne "0" ]; then
  exit 1
fi