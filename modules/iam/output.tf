output "iam_role_id" {
  description = "Role ID"
  value       = aws_iam_role.this.id
}

output "iam_instance_profile_name" {
  description = "IAM Instance profile name"
  value       = aws_iam_instance_profile.this.name
}