# resource "aws_glue_catalog_table" "citydata" {
#   name          = "mycitydata"
#   database_name = "sampledb"


#     storage_descriptor {
#         location      = format("s3://%s/", aws_s3_bucket.data_glue.id)
#         input_format  = "org.apache.hadoop.mapred.TextInputFormat"
#         output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"


#         ser_de_info {
#         serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

#         parameters = {
#             "separatorChar"     = ","
#         }
        
#         }

#         columns {
#         name = "id"
#         type = "INT"
#         }

#         columns {
#         name = "country"
#         type = "STRING"
#         }

#         columns {
#         name = "state"
#         type = "STRING"
#         }

#         columns {
#         name = "city"
#         type = "STRING"
#         }

#         columns {
#         name = "amount"
#         type = "DECIMAL"
#         }        
#     }

#     // Table Parameters
#     parameters = {
#         "classification"    = "csv"
#     }

# }

resource "aws_glue_catalog_database" "raw" {
  name          = "raw-database"
  description   = "Glue ETL for Raw Files"
  location_uri  = "/raw/database/"
}

resource "aws_glue_security_configuration" "raw_bucket" {
  name = format("%s-raw-data", var.project_name)

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

resource "aws_glue_crawler" "raw_bucket" {
  database_name = aws_glue_catalog_database.raw.name
  name          = format("%s-raw-data", var.project_name)
  role          = aws_iam_role.glue.arn

  schedule      = var.glue_raw_data_crawler_schedule

  s3_target {
    path = "s3://${aws_s3_bucket.raw_bucket.bucket}/"
  }

  security_configuration = aws_glue_security_configuration.raw_bucket.id
}