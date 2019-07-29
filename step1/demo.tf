data "terraform_remote_state" "vpc_data" {
    backend = "local"
    config = {
        path = "${path.module}/../vpc/terraform.tfstate"
    }
}

data "terraform_remote_state" "sg_data" {
    backend = "local"
    config = {
        path = "${path.module}/../security_group/terraform.tfstate"
    }
}

data "terraform_remote_state" "iam_role_data" {
    backend = "local"
    config = {
        path = "${path.module}/../iam/terraform.tfstate"
    }
}

data "aws_ssm_parameter" "ec2-password" {
  name = "${var.ec2_passwd_prameter_name}"
}

resource "aws_instance" "demo" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.key_pair}"
  instance_type        = "t2.micro"
  count                = "${var.demo_web_instance_count}"
  iam_instance_profile = "${data.terraform_remote_state.iam_role_data.outputs.demo_iam_instance_profile_name}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.sg_data.outputs.demo_sg_id}",
  ]

  subnet_id                   = "${data.terraform_remote_state.vpc_data.outputs.demo_public_subnet_1_id}"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
echo "ubuntu:${data.aws_ssm_parameter.ec2-password.value}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
  EOF

  tags = {
    Name = "demo"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2-password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl awscli unzip",
      "sudo mkdir /opt/demo-web",
      "sudo aws s3 cp s3://yongho1037-demo/demo-web/demo-web.zip /opt/demo-web/demo-web.zip",
      "cd /opt/demo-web",
      "sudo unzip demo-web.zip",
      "sudo chmod +x demo-web",
      "sudo nohup ./demo-web &",
      "sleep 20"
    ]
  }

  provisioner "remote-exec" {
    when = "destroy"
    inline = [
      "ps -ef | grep demo-web",
    ]
  }
}

resource "aws_elb" "demo" {
  name               = "demo-elb"
  subnets = ["${data.terraform_remote_state.vpc_data.outputs.demo_public_subnet_1_id}"]

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
  security_groups = ["${data.terraform_remote_state.sg_data.outputs.demo_sg_id}"]

  tags = {
    Name = "demo-elb"
  }
}

resource "aws_elb_attachment" "demo" {
  count = "${var.demo_web_instance_count}"
  elb      = "${aws_elb.demo.id}"
  instance = "${element(aws_instance.demo.*.id, count.index)}"
}