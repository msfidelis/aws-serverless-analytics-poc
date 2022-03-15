resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = format("com.amazonaws.%s.s3", var.region)
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = aws_route_table.igw_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}