variable "region" {
    default = "ap-southeast-1"
}

variable "title" {
    default = "demo_k8s"
}

variable "ec2" {
    default = {
        name = "demo_k8s"
        key_pair = "yongho1037"
        ami_name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
        ami_owner = "099720109477"      # Canonical
        passwd_prameter_name = "ec2-ubuntu-password"    # System Management / Parameter Store
    }
}

variable "ip" {
    default = {
        vpn = "119.206.206.251/32"
        vpc_range = "172.31.0.0/16"
    }
}

variable "kops" {
    default = {
        cluster_name = "demo.k8s.local"
        state_bucket_name = "yongho1037-kops-state"
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