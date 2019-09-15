resource "aws_security_group" "demo_k8s" {
  name        = "demo_k8s"
  description = "demo_k8s server"

  vpc_id = aws_vpc.demo_k8s.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.title
  }
}

resource "aws_security_group_rule" "demo_k8s_web" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = [var.ip["any_open"],var.ip["vpc_range"]]
  security_group_id = aws_security_group.demo_k8s.id

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_k8s_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = [var.ip["any_open"]]
  security_group_id = aws_security_group.demo_k8s.id

  lifecycle { create_before_destroy = true }
}