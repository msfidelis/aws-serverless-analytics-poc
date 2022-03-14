resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = format("com.amazonaws.%s.s3", var.region)
}