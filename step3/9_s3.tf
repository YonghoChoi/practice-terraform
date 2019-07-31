resource "aws_s3_bucket" "kops_state" {
  bucket = "${var.kops["state_bucket_name"]}"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}