resource "aws_security_group" "demo_web" {
  name        = "demo_web"
  description = "demo_web server"

  vpc_id = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_web"
  }
}

resource "aws_security_group_rule" "demo_web_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = [var.ip["any_open"]]
  security_group_id = aws_security_group.demo_web.id

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_web" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "TCP"
  cidr_blocks       = [var.ip["any_open"]]
  security_group_id = aws_security_group.demo_web.id

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_web_internal" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "TCP"
  source_security_group_id = aws_security_group.demo_web.id
  security_group_id = aws_security_group.demo_web.id

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_web_elb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.demo_web.id

  lifecycle { create_before_destroy = true }
}
