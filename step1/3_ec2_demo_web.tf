resource "aws_instance" "demo_web" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.ec2["key_pair"]}"
  instance_type        = "${var.ec2["instance_type"]}"
  vpc_security_group_ids = [
    "${aws_security_group.demo.id}",
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
    Name = "${var.ec2["name"]}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2-password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/demo-web"
    destination = "/home/ubuntu/demo-web"
  }

  provisioner "file" {
    source      = "${path.module}/demo-db"
    destination = "/home/ubuntu/demo-db"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/demo-db",
      "docker-compose up -d",
      "docker exec -i demo-db mysql -u${var.mysql["username"]} -p${var.mysql["password"]} <<< ./schema.sql",
      "docker exec -i demo-db mysql -u${var.mysql["username"]} -p${var.mysql["password"]} <<< 'select * from demo.User'",
      # "apt-get install -y dos2unix",
      "sed -i 's/change-db-username/${var.mysql["username"]}/g' /home/ubuntu/demo-web/run.sh",
      "sed -i 's/change-db-password/${var.mysql["password"]}/g' /home/ubuntu/demo-web/run.sh",
      "sed -i 's/change-db-ip/${self.private_ip}/g' /home/ubuntu/demo-web/run.sh",
      "cat /home/ubuntu/demo-web/run.sh",
      "chmod u+x /home/ubuntu/demo-web/run.sh",
      # "dos2unix /home/ubuntu/demo-web/run.sh",
      # "sudo dos2unix /etc/systemd/system/demo-web.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable demo-web.service",
      "sudo systemctl start demo-web.service",
      "sudo systemctl status demo-web.service",
      "sleep 200"
    ]
  }
}