provider "aws" {
  access_key = "AKIAIYTLGNVCTAUPJ6FA"
  secret_key = "SjDpSVZC1ScT+HzZvKt/840Z7sJGf9dYO5cYPQg7"
  region     = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}