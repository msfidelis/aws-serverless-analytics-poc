resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = format("%s-vpc", var.project_name)
    }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.main.id

  cidr_block                = "10.0.0.0/20"
  map_public_ip_on_launch   = true
  availability_zone     = format("%sa", var.region)

  tags = {
      "Name" = format("%s-public-1a", var.project_name)
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id = aws_vpc.main.id

  cidr_block                = "10.0.16.0/20"
  map_public_ip_on_launch   = true
  availability_zone     = format("%sb", var.region)

  tags = {
      "Name" = format("%s-public-1b", var.project_name)
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.main.id

  cidr_block                = "10.0.32.0/20"
  map_public_ip_on_launch   = true
  availability_zone     = format("%sc", var.region)

  tags = {
        "Name" = format("%s-public-1c", var.project_name)
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = format("%s-internet-gateway", var.project_name)
    }
}

resource "aws_route_table" "igw_route_table" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = format("%s-public-route", var.project_name)
    }
}

resource "aws_route" "public_internet_access" {
    route_table_id = aws_route_table.igw_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id         = aws_subnet.public_subnet_1a.id
  route_table_id    = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id         = aws_subnet.public_subnet_1b.id
  route_table_id    = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id         = aws_subnet.public_subnet_1c.id
  route_table_id    = aws_route_table.igw_route_table.id
}