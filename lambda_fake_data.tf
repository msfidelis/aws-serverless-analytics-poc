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

  source_code_hash = data.archive_file.lambda_source_package.output_sha

  runtime = "nodejs12.x"

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = [
        aws_security_group.fake_data.id
    ]
  }


  environment {
    variables = {
      BUCKET_RAW    = aws_s3_bucket.raw_bucket.id
      BUCKET_LAKE   = aws_s3_bucket.lake_bucket.id
      BATCH_SIZE    = var.lambda_fake_batch_size
    }
  }
}

resource "aws_security_group" "fake_data" {
  name        = format("%s-fake-data", var.project_name)
  description = var.project_name

  vpc_id      = var.vpc


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}