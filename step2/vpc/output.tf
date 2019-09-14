output demo_vpc_id {
    value = aws_vpc.demo.id
    description = "The ID of demo VPC"
}

output demo_public_subnet_1_id {
    value = aws_subnet.public_subnet_1.id
}

output demo_public_subnet_2_id {
    value = aws_subnet.public_subnet_2.id
}