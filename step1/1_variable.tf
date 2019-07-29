variable "region" {
    default = "ap-southeast-1"
}

variable "ec2" {
  default = {
    name = "demo_web"
    instance_type = "t2.micro"
    key_pair = "yongho1037" 
    password_parameter_name = "ec2-ubuntu-password"
    count = "3"
    ami_name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
    ami_owner = "099720109477"
  }
}

variable "ip" {
  default = {
    vpn = "0.0.0.0/0"
  }
}

variable "mysql" {
  default = {
    username = "root"
    password = "root"
  }
}