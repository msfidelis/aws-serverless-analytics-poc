resource "aws_cloudwatch_log_group" "convert_to_parquet" {
  name = "convert-to-parquet-job"
}

resource "aws_glue_job" "convert_to_parquet" {
    name     = "convert_json_to_parquet"

    role_arn = aws_iam_role.glue.arn

    worker_type         = "Standard"
    number_of_workers   = 2

    glue_version        = "3.0"

    command {
        script_location = "s3://${aws_s3_bucket.glue_assets.bucket}/convert_to_parquet.py"
        # name            = "pythonshell"
        python_version  = 3
    }

    security_configuration                    =  aws_glue_security_configuration.raw_bucket.id
    connections                                 = [ format("%s-glue-connection", var.project_name) ]

    default_arguments = {
        "--continuous-log-logGroup"             = aws_cloudwatch_log_group.convert_to_parquet.name
        "--enable-continuous-cloudwatch-log"    = true
        "--enable-continuous-log-filter"        = true
        "--enable-spark-ui"                     = true
        "--enable-metrics"                      = true
        "--LOG_LEVEL"                           = "DEBUG"
        "--job-language"                        = "python"
        "--source_bucket"                       = aws_s3_bucket.raw_bucket.id
        "--lake_bucket"                         = aws_s3_bucket.lake_bucket.id
        "--number_of_partitions"                = 3
    }

    depends_on = [
        aws_glue_connection.glue_connection
    ]
}