resource "aws_instance" "demo_es" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.ec2_es["key_pair"]}"
  instance_type        = "${var.ec2_es["instance_type"]}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.sg_data.outputs.demo_elasticstack_sg_id}",
  ]

  subnet_id                   = "${data.terraform_remote_state.vpc_data.outputs.demo_public_subnet_1_id}"
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
    Name = "${var.ec2_es["name"]}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2-password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/../../elasticstack"
    destination = "/home/ubuntu/elasticstack"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sysctl -w vm.max_map_count=262144",
      "cd /home/ubuntu/elasticstack",
      "docker-compose up -d",
      "sleep 20",
    ]
  }
}