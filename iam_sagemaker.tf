data "aws_iam_policy_document" "notebook" {

  version = "2012-10-17"

  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "sagemaker.amazonaws.com"
      ]
    }

  }

}

data "aws_iam_policy_document" "notebook_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "sagemaker:CreateTrainingJob",
      "sagemaker:DescribeTrainingJob",
      "sagemaker:CreateModel",
      "sagemaker:DescribeModel",
      "sagemaker:DeleteModel",
      "sagemaker:CreateEndpoint",
      "sagemaker:CreateEndpointConfig",
      "sagemaker:DescribeEndpoint",
      "sagemaker:DescribeEndpointConfig",
      "sagemaker:DeleteEndpoint"
    ]

    resources = [
      "*"
    ]

  }

}

resource "aws_iam_role" "notebook" {
  name               = format("%s-notebook", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.notebook.json
}


resource "aws_iam_policy" "notebook" {
  name        = format("%s-notebook", var.project_name)
  path        = "/"
  description = var.project_name

  policy = data.aws_iam_policy_document.notebook_policy.json
}

resource "aws_iam_policy_attachment" "notebook" {
  name       = format("%s-notebook", var.project_name)

  roles      = [aws_iam_role.notebook.name]

  policy_arn = aws_iam_policy.notebook.arn
}
