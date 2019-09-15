module "s3" {
  region = "ap-southeast-1"
  # source는 variables.tf, main.tf, outputs.tf 파일이 위치한 디렉터리 경로를 넣어준다.
  source = "../modules/s3"
  bucket_name = "demo-kops-yongho1037"
}