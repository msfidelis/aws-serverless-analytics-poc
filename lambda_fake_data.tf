resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "cd ./lambda/fake-data ; rm -rf node_modules && npm install --only=prod"
  }

  triggers = {
    release = timestamp()
  }
}

data "archive_file" "lambda_source_package" {
    type             = "zip"
    source_dir       = "./lambda/fake-data"
    output_path      = "fake-data-lambda.zip"
    output_file_mode = "0666"

    depends_on = [null_resource.install_dependencies]
}

resource "aws_lambda_function" "fake_data" {
  filename      = "fake-data-lambda.zip"
  function_name = format("%s-fake-data", var.project_name)
  role          = aws_iam_role.fake_data.arn
  handler       = "index.handler"
  timeout       = 120  

  source_code_hash = filesha256("fake-data-lambda.zip")

  runtime = "nodejs12.x"

  vpc_config {
    subnet_ids         = [
      aws_subnet.public_subnet_1a.id,
      aws_subnet.public_subnet_1b.id,
      aws_subnet.public_subnet_1c.id

    ]
    security_group_ids = [
        aws_security_group.fake_data.id
    ]
  }
  


  environment {
    variables = {
      BUCKET_RAW      = aws_s3_bucket.raw_bucket.id
      BUCKET_LAKE     = aws_s3_bucket.lake_bucket.id
      BATCH_SIZE      = var.lambda_fake_batch_size
      NUMBER_OF_FILES = var.lambda_fake_number_files
      VERSION_SHA256  =  data.archive_file.lambda_source_package.output_sha
    }
  }
}

resource "aws_security_group" "fake_data" {
  name        = format("%s-fake-data", var.project_name)
  description = var.project_name

  vpc_id      = aws_vpc.main.id


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_cloudwatch_event_rule" "fake_data" {
  name                = "fake-data-cron"
  schedule_expression = var.lambda_fake_cron
}

resource "aws_cloudwatch_event_target" "fake_data" {
  rule      = aws_cloudwatch_event_rule.fake_data.name
  target_id = "lambda"
  arn       = aws_lambda_function.fake_data.arn
}

resource "aws_lambda_permission" "fake_data" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fake_data.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.fake_data.arn
}