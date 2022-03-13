variable "project_name" {
  default = "serverless-analytics-poc"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc" {
    default = "vpc-ba8b92c1"
}

variable "subnets" {
  type      = list
  default   = [
      "subnet-29954875",
      "subnet-c832eeaf",
      "subnet-23a9760d"
  ]
}

variable "redshift_setup" {
  default = false
}

variable "glue_setup" {
  default = false
}

variable "lambda_fake_batch_size" {
  default = 1
}