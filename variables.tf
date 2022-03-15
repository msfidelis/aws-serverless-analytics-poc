variable "project_name" {
  default = "serverless-analytics-poc"
}

variable "region" {
  default = "us-east-1"
}

variable "redshift_setup" {
  default = false
}

variable "glue_setup" {
  default = false
}

variable "lambda_fake_batch_size" {
  default = 10
}

variable "lambda_fake_number_files" {
  default = 10 
}

variable "lambda_fake_cron" {
  default = "rate(1 minute)"
}

variable "glue_raw_data_crawler_schedule" {
   default = "cron(30 * * * ? *)"
}

variable "glue_data_lake_crawler_schedule" {
  default = "cron(30 * * * ? *)"
}