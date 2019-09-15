variable "name" {
    type = "string"
    default = "demo_k8s"
}

variable "key_pair" {
    type = "string"
}

variable "ami_name" {
    type = "string"
    default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "ami_owner" {
    type = "string"
    default = "099720109477"
}

variable "iam_instance_profile_name" {
    type = "string"
}

variable "security_group_ids" {
    type = "list"
}

variable "subnet_id" {
    type = "string"
}

variable "vpc_id" {
    type = "string"
}

variable "cidr_block" {
    type = "string"
}

variable "ssh_password_parameter_name" {
    type = "string"
    default = "ec2-ubuntu-password"
}

variable "s3_state_bucket_domain_name" {
    type = "string"
}

variable "tags" {
    description = "모든 리소스에 추가되는 tag 맵"
    type        = "map"
}

variable "kops" {
    type = "map"
    default = {
        cluster_name = "demo.k8s.local"
        node_count = "1"
        node_size = "t2.medium"
        node_volume_size = "20"
        master_count = "1"
        master_size = "t2.medium"
        master_volume_size = "20"
        topology = "public"
        api_loadbalancer_type = "public"
        admin_access = "0.0.0.0/0"
        networking = "calico"
        cloud_labels = "email=yongho1037@gmail.com"
    }
}