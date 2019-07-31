data "aws_availability_zones" "available" {
  # state는 가용 영역의 상태로 필터링 (아래 설정은 사용 가능한 availability zone들을 필터링)
  state = "available"
}