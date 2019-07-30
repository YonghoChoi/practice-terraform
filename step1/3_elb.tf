
resource "aws_elb" "demo" {
  name               = "demo-elb"
  subnets = ["${aws_subnet.public_subnet_1.id}"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups = ["${aws_security_group.demo_web.id}"]

  tags = {
    Name = "demo-elb"
  }
}

resource "aws_elb_attachment" "demo" {
  count = "${var.ec2["count"]}"
  elb      = "${aws_elb.demo.id}"
  instance = "${element(aws_instance.demo_web.*.id, count.index)}"
}