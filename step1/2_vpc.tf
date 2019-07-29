resource "aws_vpc" "demo" {
  cidr_block = "172.16.0.0/16"

  //  dns 관련 두 속성 중 하나라도 false이면 DNS 이름을 받지 못함

  // 퍼블릭 IP 주소를 갖는 인스턴스가 해당하는 퍼블릭 DNS 호스트 이름을 받는지 여부
  enable_dns_hostnames = true

  // DNS 확인이 지원되는지 여부
  enable_dns_support = true

  // default : 공유된 하드웨어, dedicated : 단일 테넌트 하드웨어, host : 격리된 전용 호스트
  instance_tenancy = "default"

  tags = {
    Name = "demo"
  }
}