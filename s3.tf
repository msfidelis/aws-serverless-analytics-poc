resource "aws_s3_bucket" "data" {
  bucket = format("aws-data-serverless-analytics-%s", data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_analytics_configuration" "citydata" {
  bucket = aws_s3_bucket.data.bucket
  name   = "CityData"

  filter {
    prefix = "CityData"
  }
}

resource "aws_s3_bucket_object" "citydata" {
  bucket = aws_s3_bucket.data.bucket
  key    = "CityData.csv"
  source = "./data/CityData.csv"

  etag = filemd5("./data/CityData.csv")
}

resource "aws_s3_bucket_object" "citydata1" {
  bucket = aws_s3_bucket.data.bucket
  key    = "CityData1.csv"
  source = "./data/CityData1.csv"

  etag = filemd5("./data/CityData1.csv")
}

resource "aws_s3_bucket_object" "citydata2" {
  bucket = aws_s3_bucket.data.bucket
  key    = "CityData2.csv"
  source = "./data/CityData2.csv"

  etag = filemd5("./data/CityData2.csv")
}