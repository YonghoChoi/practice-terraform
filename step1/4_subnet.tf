resource "aws_subnet" "public_subnet_1" {
  vpc_id            = "${aws_vpc.demo.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block        = "172.16.1.0/24"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = "${aws_vpc.demo.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block        = "172.16.2.0/24"

  tags = {
    Name = "public-subnet-2"
  }
}