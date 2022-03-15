resource "aws_cloudwatch_log_group" "convert_to_parquet" {
  name = "convert-to-parquet-job"
}

resource "aws_glue_job" "convert_to_parquet" {
    name     = "convert_json_to_parquet"

    role_arn = aws_iam_role.glue.arn

    command {
        script_location = "s3://${aws_s3_bucket.glue_assets.bucket}/convert_to_parquet.py"
    }

    security_configuration                    =  aws_glue_security_configuration.raw_bucket.id

    default_arguments = {
        "--continuous-log-logGroup"             = aws_cloudwatch_log_group.convert_to_parquet.name
        "--enable-continuous-cloudwatch-log"    = "true"
        "--enable-continuous-log-filter"        = "true"
        "--enable-metrics"                      = "true"
        "--source-bucket"                       = aws_s3_bucket.raw_bucket.id
        "--lake-bucket"                         = aws_s3_bucket.lake_bucket.id
        "--number-of-partitions"                = 3
    }
}