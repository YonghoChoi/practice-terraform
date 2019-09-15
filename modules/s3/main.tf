resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}