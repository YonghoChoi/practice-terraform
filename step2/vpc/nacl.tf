resource "aws_default_network_acl" "demo_default" {
  default_network_acl_id = aws_vpc.demo.default_network_acl_id

  ingress {              # 들어오는 트래픽(Inbound) 설정
    protocol   = -1      # 프로토콜을 지정 (-1인 경우 모든 프로토콜)
    rule_no    = 100     # 우선 순위 설정
    action     = "allow" # 허용 여부 (allow | deny)
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {          # 나가는 트래픽(Outbound) 설정
    protocol   = -1 # 설정은 ingress와 동일
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]

  tags = {
    Name = "demo-default"
  }
}