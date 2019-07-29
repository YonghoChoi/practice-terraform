resource "aws_s3_bucket" "demo" {
  bucket = "yongho1037-demo"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}