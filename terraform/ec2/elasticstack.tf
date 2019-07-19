# resource "aws_instance" "demo_elasticstack" {
#   ami                  = "${var.ubuntu_ami}"
#   availability_zone    = "${var.az_1}"
#   key_name             = "${var.key_pair}"
#   instance_type        = "t2.micro"
#   iam_instance_profile = "${data.terraform_remote_state.iam_role_data.outputs.demo_iam_instance_profile_name}"
#   vpc_security_group_ids = [
#     "${data.terraform_remote_state.sg_data.outputs.demo_elasticstack_sg_id}",
#   ]

#   subnet_id                   = "${data.terraform_remote_state.vpc_data.outputs.demo_public_subnet_1_id}"
#   associate_public_ip_address = true
#   user_data = <<EOF
# #!/bin/bash
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf
# echo "ubuntu:${data.aws_ssm_parameter.ec2-password.value}" | chpasswd
# sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
# service sshd restart
#   EOF

#   tags = {
#     Name = "demo-elasticstack"
#   }

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     password    = "${data.aws_ssm_parameter.ec2-password.value}"
#     host        = "${self.public_ip}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
#       "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
#       "sudo apt-key fingerprint 0EBFCD88",
#       "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
#       "sudo apt-get update",
#       "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
#       "sudo usermod -aG docker ubuntu",
#       "sudo apt-get install -y python-pip",
#       "sudo pip install docker-compose",
#       "sudo sysctl -w vm.max_map_count=262144",
#       "git clone https://github.com/elastic/stack-docker.git",
#       "cd stack-docker",
#       "sudo docker-compose -f setup.yml up",
#     ]
#   }

#   provisioner "remote-exec" {
#     when = "destroy"
#     inline = [
#       "ps -ef | grep demo-web",
#     ]
#   }
# }