
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

resource "aws_security_group_rule" "demo_elasticstack_es_internal" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "TCP"
  source_security_group_id = "${aws_security_group.demo.id}"
  security_group_id = "${aws_security_group.demo_elasticstack.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_elasticstack_kibana_internal" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "TCP"
  source_security_group_id = "${aws_security_group.demo.id}"
  security_group_id = "${aws_security_group.demo_elasticstack.id}"

  lifecycle { create_before_destroy = true }
}