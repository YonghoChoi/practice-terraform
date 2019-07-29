data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ec2["ami_name"]}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["${var.ec2["ami_owner"]}"]
}

data "aws_ssm_parameter" "ec2-password" {
  name = "${var.ec2["password_parameter_name"]}"
}
