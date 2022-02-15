resource "aws_redshift_cluster" "main" {
    cluster_identifier    = "redshift-cluster-analytics"
    database_name         = "mydb"
    master_username       = "fidelaomilgrau"
    master_password       = "EuSouBemLind0"
    node_type             = "dc2.large"
    cluster_type          = "single-node"

    port                  = 5439
    encrypted             = true

    iam_roles = [
        aws_iam_role.redshift.arn
    ]

    cluster_subnet_group_name = aws_redshift_subnet_group.main.name

    vpc_security_group_ids    = [
        aws_security_group.main.id
    ]

    kms_key_id            = aws_kms_key.main.arn
    skip_final_snapshot = true # Do not use in production
}

resource "aws_redshift_subnet_group" "main" {
  name       = "redshift-cluster-analytics"
  subnet_ids = var.subnets
}

resource "aws_security_group" "main" {
    name    = "redshift-cluster-analytics"

    vpc_id  = data.aws_vpc.main.id

    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

}

resource "aws_security_group_rule" "ingress_vpc" {
    cidr_blocks =  data.aws_vpc.main.cidr_block_associations.*.cidr_block
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"

    security_group_id = aws_security_group.main.id
    type = "ingress"
}