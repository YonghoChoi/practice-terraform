variable "region" {}

variable "ec2_demo" {
   default = {
      name = "demo"
      instance_type = "t2.micro"
      key_pair = "yongho1037"
   }
}

variable "ec2_es" {
   default = {
      name = "demo_es"
      instance_type = "t2.medium"
      key_pair = "yongho1037"
   }
}

variable "ami" {
   default = {
      name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      owner = "099720109477"
   }
}

variable "parameter_name" {
   default = {
      ec2_password = "ec2-ubuntu-password"
   }
}

variable "demo_web_lb_eip_id" {
   default = "eipalloc-045a90d425b788129"
}