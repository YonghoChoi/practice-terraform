resource "aws_security_group" "demo_db" {
  name        = "demo_db"
  description = "demo_db server"

  vpc_id = "${aws_vpc.demo.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_db"
  }
}

resource "aws_security_group_rule" "web_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["${var.ip["vpn"]}"]
  security_group_id = "${aws_security_group.demo_db.id}"

  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "demo_db" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "TCP"
  source_security_group_id = "${aws_security_group.demo_web.id}"
  security_group_id = "${aws_security_group.demo_db.id}"

  lifecycle { create_before_destroy = true }
}