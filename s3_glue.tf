resource "aws_s3_bucket" "glue_assets" {
  bucket = format("aws-glue-assets-%s-%s", var.project_name, data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_acl" "glue_assets" {
    bucket = aws_s3_bucket.glue_assets.id
    acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_assets" {
  bucket = aws_s3_bucket.glue_assets.id

  rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id   = aws_kms_key.main.arn
        sse_algorithm       = "aws:kms"
      }
  }
}

resource "aws_s3_object" "convert_to_parquet" {
  bucket = aws_s3_bucket.glue_assets.bucket
  key    = "convert_to_parquet.py"
  source = "./glue/jobs/convert_to_parquet.py"

  etag = filemd5("./glue/jobs/convert_to_parquet.py")
}


resource "aws_s3_bucket" "glue_temp" {
  bucket = format("aws-glue-temp-%s", data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_acl" "glue_temp" {
    bucket = aws_s3_bucket.glue_temp.id
    acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_temp" {
  bucket = aws_s3_bucket.glue_temp.id

  rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id   = aws_kms_key.main.arn
        sse_algorithm       = "aws:kms"
      }
  }
}