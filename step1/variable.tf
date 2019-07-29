variable "region" {
    default = "ap-southeast-1"
}

variable "key_pair" {
    default = "yongho1037"
}

variable "ec2_passwd_prameter_name" {
   default = "ec2-ubuntu-password"
   description = "Parameter name of AWS Parameter Store"
}

variable "demo_web_instance_count" {
   default = "3"
}

variable "vpn_ip" {
    default = "0.0.0.0/0"
    description = "VPN IP for accessing the EC2 instance"
}

variable "cp_path_demo_web_docker" {
  default = "E:/works/demo_web/docker"
}

variable "cp_path_demo_web_binary" {
  default = "E:/works/demo_web/bin"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}