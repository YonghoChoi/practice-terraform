output demo_sg_id {
    value = aws_security_group.demo.id
    description = "The ID of demo Security Group"
}

output demo_elasticstack_sg_id {
    value = aws_security_group.demo_elasticstack.id
    description = "The ID of demo elasticstack Security Group"
}