variable "region" {
    description = "VPC가 생성될 리전 정보"
    type        = "string"
}

variable "name" {
    description = "모든 리소스의 Name 태그"
    type        = "string"
}

variable "tags" {
    description = "모든 리소스에 추가되는 tag 맵"
    type        = "map"
}