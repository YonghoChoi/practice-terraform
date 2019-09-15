resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  //  dns 관련 두 속성 중 하나라도 false이면 DNS 이름을 받지 못함

  // 퍼블릭 IP 주소를 갖는 인스턴스가 해당하는 퍼블릭 DNS 호스트 이름을 받는지 여부
  enable_dns_hostnames = true

  // DNS 확인이 지원되는지 여부
  enable_dns_support = true

  // default : 공유된 하드웨어, dedicated : 단일 테넌트 하드웨어, host : 격리된 전용 호스트
  instance_tenancy = "default"

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

resource "aws_subnet" "this" {
  count = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.public_subnets[count.index]

  tags = merge(var.tags, map("Name", format("%s-public-%s", var.name, count.index)))
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {              //들어오는 트래픽(Inbound) 설정
    protocol   = -1      //프로토콜을 지정 (-1인 경우 모든 프로토콜)
    rule_no    = 100     //우선 순위 설정
    action     = "allow" //허용 여부 (allow | deny)
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {          //나가는 트래픽(Outbound) 설정
    protocol   = -1 //설정은 ingress와 동일
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = aws_subnet.this.*.id

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

//demo_k8s_public
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

resource "aws_route_table_association" "this" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this.id
}