variable "region" {}
variable "az_1" {}
variable "az_2" {}
variable "amazon_linux_ami" {}
variable "ubuntu_ami" {}
variable "key_pair" {}

variable "ec2_passwd_prameter_name" {
   default = "ec2-ubuntu-password"
   description = "Parameter name of AWS Parameter Store"
}

variable "demo_web_instance_count" {
   default = "3"
}

variable "demo_web_lb_eip_id" {
   default = "eipalloc-045a90d425b788129"
}