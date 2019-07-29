data "aws_ssm_parameter" "ec2-password" {
  name = "${var.ec2_passwd_prameter_name}"
}

resource "aws_instance" "demo_web" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.key_pair}"
  instance_type        = "t2.micro"
  vpc_security_group_ids = [
    "${aws_security_group.demo_web.id}",
  ]

  subnet_id                   = "${aws_subnet.public_subnet_1.id}"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
# docker install
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common awscli unzip dos2unix
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# set password
echo "ubuntu:${data.aws_ssm_parameter.ec2-password.value}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
  EOF

  tags = {
    Name = "demo_web"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2-password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "${var.cp_path_demo_web_docker}"
    destination = "/home/ubuntu/docker"
  }

  provisioner "file" {
    source      = "${var.cp_path_demo_web_binary}"
    destination = "/home/ubuntu/demo-web"
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose -f /home/ubuntu/docker/docker-compose.yml up -d",
      "sleep 200"
    ]
  }
}