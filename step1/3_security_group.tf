resource "aws_security_group" "demo" {
  name        = "demo"
  description = "demo server"

  vpc_id = "${aws_vpc.demo.id}"

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

resource "aws_security_group_rule" "web_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["${var.ip["vpn"]}"]
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
