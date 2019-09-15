module "vpc" {
  # source는 variables.tf, main.tf, outputs.tf 파일이 위치한 디렉터리 경로를 넣어준다.
  source = "../modules/vpc"

  region = "ap-southeast-1"
  # VPC이름을 넣어준다. 이 값은 VPC module이 생성하는 모든 리소스 이름의 prefix가 된다.
  name = "demo_k8s"
  cidr_block = "172.16.0.0/16"

  # VPC의 Public Subnet CIDR block을 정의한다.
  public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]

  # VPC module이 생성하는 모든 리소스에 기본으로 입력될 Tag를 정의한다.
  tags = {
    "TerraformManaged" = "true"
  }
}