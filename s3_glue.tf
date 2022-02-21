resource "aws_s3_bucket" "data_glue" {
  bucket = format("aws-glue-serverless-analytics-%s", data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_object" "citydata_0" {
  bucket = aws_s3_bucket.data_glue.bucket
  key    = "CityData.csv"
  source = "./data/CityData.csv"

  etag = filemd5("./data/CityData.csv")
}

resource "aws_s3_bucket_object" "citydata_1" {
  bucket = aws_s3_bucket.data_glue.bucket
  key    = "CityData1.csv"
  source = "./data/CityData1.csv"

  etag = filemd5("./data/CityData1.csv")
}

resource "aws_s3_bucket_object" "citydata_2" {
  bucket = aws_s3_bucket.data_glue.bucket
  key    = "CityData2.csv"
  source = "./data/CityData2.csv"

  etag = filemd5("./data/CityData2.csv")
}