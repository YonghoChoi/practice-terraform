resource "aws_internet_gateway" "demo_k8s" {
  vpc_id = aws_vpc.demo_k8s.id

  tags = {
    Name = var.title
  }
}