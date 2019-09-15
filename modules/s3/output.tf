output "s3_bucket_id" {
  description = "S3 Bucket ID"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_name" {
  description = "S3 Bucket name"
  value       = aws_s3_bucket.this.bucket
}