module "ec2" {
  # source는 variables.tf, main.tf, outputs.tf 파일이 위치한 디렉터리 경로를 넣어준다.
  source = "../modules/ec2"
  name = "demo_k8s"
  key_pair = "yongho1037"
  ami_name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ami_owner = "099720109477"      # Canonical
  ssh_password_parameter_name = "ec2-ubuntu-password"    # System Management / Parameter Store
  s3_state_bucket_domain_name = module.s3.s3_bucket_name
  security_group_ids = [module.security_group.this_security_group_id]
  subnet_id = module.vpc.public_subnets_ids[0]
  cidr_block = module.vpc.cidr_block
  vpc_id = module.vpc.vpc_id
  iam_instance_profile_name = module.iam.iam_instance_profile_name
  kops = {
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
  tags = {
    "TerraformManaged" = "true"
  }
}