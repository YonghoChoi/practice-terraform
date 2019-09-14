resource "aws_instance" "demo_web" {
  ami                  = data.aws_ami.ubuntu.id
  availability_zone    = data.aws_availability_zones.available.names[0]
  key_name             = var.ec2["key_pair"]
  count                = var.ec2["count"]
  instance_type        = var.ec2["instance_type"]
  vpc_security_group_ids = [
    aws_security_group.demo_web.id,
  ]

  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common awscli unzip dos2unix

# set password
echo "ubuntu:${var.ec2["password"]}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
  EOF

  tags = {
    Name = var.ec2["web_name"]
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/demo-web"
    command = "./build.sh"
    interpreter = ["sh"]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = var.ec2["password"]
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/demo-web/bin"
    destination = "/home/ubuntu/demo-web"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/demo-web",
      "dos2unix ./run.sh",
      "dos2unix ./demo-web.service",
      "sed -i 's/change-db-username/${var.mysql["username"]}/g' ./run.sh",
      "sed -i 's/change-db-password/${var.mysql["password"]}/g' ./run.sh",
      "sed -i 's/change-db-ip/${aws_instance.demo_db.private_ip}/g' ./run.sh",
      "chmod u+x demo-web",
      "chmod u+x ./run.sh",
      "cat ./run.sh",
      
      "sudo cp ./demo-web.service /etc/systemd/system/demo-web.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable demo-web.service",
      "sudo systemctl start demo-web.service",
      "sleep 20"
    ]
  }

  depends_on = ["aws_instance.demo_db"]
}