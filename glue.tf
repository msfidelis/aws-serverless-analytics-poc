resource "aws_glue_catalog_database" "db" {
  name          = "sampledb"
  description   = "sample database"
  location_uri  = "/samples/database/"
}

resource "aws_glue_catalog_table" "citydata" {
  name          = "mycitydata"
  database_name = "sampledb"


    storage_descriptor {
        location      = format("s3://%s/", aws_s3_bucket.data_glue.id)
        input_format  = "org.apache.hadoop.mapred.TextInputFormat"
        output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"


        ser_de_info {
        serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

        parameters = {
            "separatorChar"     = ","
        }
        
        }

        columns {
        name = "id"
        type = "INT"
        }

        columns {
        name = "country"
        type = "STRING"
        }

        columns {
        name = "state"
        type = "STRING"
        }

        columns {
        name = "city"
        type = "STRING"
        }

        columns {
        name = "amount"
        type = "DECIMAL"
        }        
    }

    // Table Parameters
    parameters = {
        "classification"    = "csv"
    }

}

resource "aws_glue_crawler" "cities" {
  database_name = aws_glue_catalog_database.db.name
  name          = "cities"
  role          = aws_iam_role.glue.arn

  s3_target {
    path = "s3://${aws_s3_bucket.data_glue.bucket}"
  }
}