output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnets_ids" {
  description = "Public Subnet ID 리스트"
  value       = aws_subnet.this.*.id
}

output "cidr_block" {
  description = "VPC CIDR Block"
  value       = aws_vpc.this.cidr_block
}