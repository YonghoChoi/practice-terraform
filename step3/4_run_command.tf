resource "null_resource" "run_coomand" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = data.aws_ssm_parameter.ec2_password.value
    host        = aws_instance.demo_k8s.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/sample"
    destination = "/home/ubuntu/sample"
  }

  provisioner "remote-exec" {
    inline = [
      "dos2unix ~/sample/run.sh",
      "chmod +x ~/sample/run.sh",
      "~/sample/run.sh",
      "sudo kubectl create -f ~/sample/guestbook.yml",
      "sleep 10",
      "sudo kubectl get pods",
      "sudo kubectl get services",
    ]
  }

  depends_on = ["aws_instance.demo_k8s"]
}