resource "null_resource" "run_coomand" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = "${data.aws_ssm_parameter.ec2_password.value}"
    host        = "${aws_instance.demo_k8s.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [<<EOF
until sudo kubectl get nodes &> /dev/null
do
    echo "Waiting for provisioning kubernetes ..."
    sleep 5
done
sudo kubectl create -f ~/sample/guestbook.yml
    EOF
    ]
  }

  depends_on = ["aws_instance.demo_k8s"]
}