variable "region" {}

variable "ec2" {
   default = {
      key_pair = "yongho1037"
      password = "demo"
   }
}

variable "ec2_demo" {
   default = {
      name = "demo"
      instance_type = "t2.micro"

   }
}

variable "ec2_es" {
   default = {
      name = "demo_es"
      instance_type = "t2.medium"
   }
}

variable "ami" {
   default = {
      name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      owner = "099720109477"
   }
}