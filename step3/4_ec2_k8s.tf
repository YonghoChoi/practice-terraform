resource "aws_instance" "demo_k8s" {
  ami                  = "${data.aws_ami.ubuntu.id}"
  availability_zone    = "${data.aws_availability_zones.available.names[0]}"
  key_name             = "${var.ec2["key_pair"]}"
  instance_type        = "t2.medium"
  iam_instance_profile = "${aws_iam_instance_profile.demo_k8s_profile.name}"
  vpc_security_group_ids = [
    "${aws_security_group.demo_k8s.id}",
  ]

  subnet_id                   = "${aws_subnet.public_subnet_1.id}"
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y curl awscli

# set password
echo "ubuntu:${data.aws_ssm_parameter.ec2_password.value}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
  EOF

  tags = {
    Name = "${var.title}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2_password.value}"
    host        = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/sample/"
    destination = "/home/ubuntu/sample"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '\"' -f 4)/kops-linux-amd64",
      "chmod +x kops",
      "sudo mv kops /usr/local/bin/",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl",
      "sudo kubectl version",
      "cat /dev/zero | ssh-keygen -q -N ''",
      "echo '${aws_s3_bucket.kops_state.bucket_domain_name}'",
      "sudo kops create secret --name ${var.kops["cluster_name"]} --state s3://${var.kops["state_bucket_name"]} sshpublickey admin -i ~/.ssh/id_rsa.pub",
      "sudo kops delete cluster --name ${var.kops["cluster_name"]} --state s3://${var.kops["state_bucket_name"]} --yes",
      "sudo kops create cluster --name ${var.kops["cluster_name"]} --state s3://${var.kops["state_bucket_name"]} --zones=${data.aws_availability_zones.available.names[0]} --master-zones=${data.aws_availability_zones.available.names[0]} --node-count=${var.kops["node_count"]} --node-size=${var.kops["node_size"]} --node-volume-size=${var.kops["node_volume_size"]} --node-security-groups=${aws_security_group.demo_k8s.id} --master-count=${var.kops["master_count"]} --master-size=${var.kops["master_size"]} --master-volume-size=${var.kops["master_volume_size"]} --master-security-groups=${aws_security_group.demo_k8s.id} --topology=${var.kops["topology"]} --api-loadbalancer-type=${var.kops["api_loadbalancer_type"]} --subnets=${aws_subnet.public_subnet_1.id},${aws_subnet.public_subnet_2.id} --admin-access=${var.kops["admin_access"]} --vpc=${aws_vpc.demo_k8s.id} --network-cidr=${aws_vpc.demo_k8s.cidr_block} --utility-subnets=${aws_subnet.public_subnet_1.id},${aws_subnet.public_subnet_2.id} --image=${data.aws_ami.ubuntu.id} --networking=${var.kops["networking"]} --cloud-labels '${var.kops["cloud_labels"]}' --yes",
    ]
  }

  provisioner "remote-exec" {
    when    = "destroy"
    inline = [
      "sudo kops delete cluster --name ${var.kops["cluster_name"]} --state s3://${var.kops["state_bucket_name"]} --yes",
    ]
  }
}