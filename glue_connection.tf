resource "aws_glue_connection" "glue_connection" {
    connection_type  = "NETWORK"

    name = format("%s-glue-connection", var.project_name)

    physical_connection_requirements {
        availability_zone      = aws_subnet.public_subnet_1a.availability_zone
        security_group_id_list = [aws_security_group.glue_connection.id]
        subnet_id              = aws_subnet.public_subnet_1a.id
    }
}

resource "aws_security_group" "glue_connection" {
  name        = format("%s-glue-connection", var.project_name)
  description = var.project_name

  vpc_id      = aws_vpc.main.id


  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}