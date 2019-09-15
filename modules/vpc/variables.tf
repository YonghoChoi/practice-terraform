variable "region" {
    description = "VPC가 생성될 리전 정보"
    type        = "string"
}

variable "name" {
    description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
    type        = "string"
}

variable "cidr_block" {
    description = "VPC에 할당한 CIDR block"
    type        = "string"
}

variable "public_subnets" {
    description = "Public Subnet IP 리스트"
    type        = "list"
}

variable "tags" {
    description = "모든 리소스에 추가되는 tag 맵"
    type        = "map"
}