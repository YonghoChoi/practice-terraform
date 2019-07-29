data "terraform_remote_state" "vpc_data" {
    backend = "local"
    config = {
        path = "${path.module}/../vpc/terraform.tfstate"
    }
}

resource "aws_security_group" "demo" {
  name        = "demo"
  description = "demo server"

  vpc_id = "${data.terraform_remote_state.vpc_data.outputs.demo_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo"
  }
}

resource "aws_security_group_rule" "demo_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_web" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "TCP"
  source_security_group_id = "${aws_security_group.demo.id}"
  security_group_id = "${aws_security_group.demo.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_elb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group" "demo_elasticstack" {
  name        = "demo-elasticstach"
  description = "demo elasticstack"

  vpc_id = "${data.terraform_remote_state.vpc_data.outputs.demo_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-elasticstack"
  }
}

resource "aws_security_group_rule" "demo_elasticstack_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo_elasticstack.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_elasticstack_kibana" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo_elasticstack.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_elasticstack_es" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "TCP"
  source_security_group_id = "${aws_security_group.demo.id}"
  security_group_id = "${aws_security_group.demo_elasticstack.id}"

  lifecycle { create_before_destroy = true }
}