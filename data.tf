data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  id = var.vpc
}