data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [var.ami_owner]
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "ec2_password" {
  name = var.ssh_password_parameter_name
}