resource "aws_glue_catalog_database" "lake" {
  name          = format("%s-data-lake", var.project_name)
  description   = "Glue ETL for lake Files"
  location_uri  = "/lake/database/"
}

resource "aws_glue_security_configuration" "lake_bucket" {
  name = "lake-data"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "DISABLED"
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "DISABLED"
    }

    s3_encryption {
      kms_key_arn        = aws_kms_key.main.arn
      s3_encryption_mode = "SSE-KMS"
    }
  }
}

resource "aws_glue_crawler" "lake_bucket" {
  database_name = aws_glue_catalog_database.lake.name
  name          = format("%s-data-lake", var.project_name)
  role          = aws_iam_role.glue.arn

  schedule      = var.glue_data_lake_crawler_schedule

  s3_target {
    path = "s3://${aws_s3_bucket.lake_bucket.bucket}/"
  }

  security_configuration = aws_glue_security_configuration.lake_bucket.id
}