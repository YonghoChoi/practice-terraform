resource "aws_instance" "demo_db" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.ec2["key_pair"]}"
  instance_type        = "${var.ec2["instance_type"]}"
  vpc_security_group_ids = [
    "${aws_security_group.demo_db.id}",
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
    Name = "${var.ec2["db_name"]}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2-password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/demo-db"
    destination = "/home/ubuntu/demo-db"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/demo-db",
      "dos2unix ./schema.sql",
      "docker-compose up -d",
      # mysqld.sock 파일 생성 확인을 위해 임시로 sleep 구문을 추가함
      "sleep 10",
      "docker exec -i demo-db ls -l /var/run/mysqld",
      "sleep 10",
      "docker exec -i demo-db ls -l /var/run/mysqld",
      "sleep 10",
      "docker exec -i demo-db ls -l /var/run/mysqld",
      "sleep 10",
      "docker exec -i demo-db mysql -h localhost -uroot -proot < ./schema.sql",
      "sleep 10"
    ]
  }
}