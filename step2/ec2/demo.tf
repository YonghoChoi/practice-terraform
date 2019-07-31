resource "aws_instance" "demo" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.ec2_demo["key_pair"]}"
  instance_type        = "${var.ec2_demo["instance_type"]}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.sg_data.outputs.demo_sg_id}",
  ]

  subnet_id                   = "${data.terraform_remote_state.vpc_data.outputs.demo_public_subnet_1_id}"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common awscli unzip dos2unix

# set password
echo "ubuntu:${data.aws_ssm_parameter.ec2-password.value}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
  EOF

  tags = {
    Name = "${var.ec2_demo["name"]}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2-password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/conf/metricbeat.yml"
    destination = "/home/ubuntu/metricbeat.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/change-es-host/${aws_instance.demo_es.private_ip}/g' ~/metricbeat.yml",
      "curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.2.0-amd64.deb",
      "sudo dpkg -i metricbeat-7.2.0-amd64.deb",
      "rm -rf metricbeat-7.2.0-amd64.deb",
      "sudo mv ~/metricbeat.yml /etc/metricbeat/metricbeat.yml",
      "sudo chown root:root /etc/metricbeat/metricbeat.yml",
      "sudo systemctl enable metricbeat.service",
      "sudo service metricbeat start",
      "sudo metricbeat setup --dashboards",
      "sleep 20"
    ]
  }

  depends_on = ["aws_instance.demo_es"]
}