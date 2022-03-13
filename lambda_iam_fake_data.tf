data "aws_iam_policy_document" "fake_data_assume_role" {

  version = "2012-10-17"

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }

  }

}

data "aws_iam_policy_document" "fake_data" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:CreateNetworkInterface",
      "ec2:AttachNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "autoscaling:CompleteLifecycleAction"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "s3:*"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "logs:*"
    ]

    resources = [
      "*"
    ]

  }


  statement {

    effect = "Allow"
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

  }
}

resource "aws_iam_role" "fake_data" {
  name               = format("%s-fake-data", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.fake_data_assume_role.json
}


resource "aws_iam_policy" "fake_lambda" {
  name        = format("%s-fake-data-policy", var.project_name)
  path        = "/"
  description = var.project_name

  policy = data.aws_iam_policy_document.fake_data.json
}

resource "aws_iam_policy_attachment" "fake_lambda" {
    name       = "cluster_autoscaler"
    roles      = [ 
      aws_iam_role.fake_data.name
    ]

    policy_arn = aws_iam_policy.fake_lambda.arn
}