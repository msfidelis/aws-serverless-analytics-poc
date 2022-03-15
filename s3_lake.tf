resource "aws_s3_bucket" "lake_bucket" {
  bucket = format("aws-glue-lake-data-bucket-%s", data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_acl" "lake_bucket" {
    bucket = aws_s3_bucket.lake_bucket.id
    acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lake_bucket" {
  bucket = aws_s3_bucket.lake_bucket.id

  rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id   = aws_kms_key.main.arn
        sse_algorithm       = "aws:kms"
      }
  }
}