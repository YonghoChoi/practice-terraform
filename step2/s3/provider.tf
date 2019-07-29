# 프로바이더 플러그인 설치 및 초기 설정을 위해 terraform init 명령 해야함
provider "aws" {
  region = "${var.region}"
}
