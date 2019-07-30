variable "region" {
    default = "ap-southeast-1"
}

variable "ec2" {
  default = {
    web_name = "demo_web"
    db_name = "demo_db"
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
    vpn = "119.206.206.251/32"
  }
}

variable "mysql" {
  default = {
    username = "root"
    password = "root"
  }
}