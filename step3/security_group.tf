module "security_group" {
  // 참고 : https://github.com/terraform-aws-modules/terraform-aws-security-group
  source = "terraform-aws-modules/security-group/aws"

  name = "demo_k8s"
  description = "Allows access to APP Subnet from Public on port 80, and office on ports 3389/5985"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}