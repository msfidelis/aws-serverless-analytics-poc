data "aws_iam_policy_document" "glue" {

  version = "2012-10-17"

  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "glue.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "glue_custom" {

  version = "2012-10-17"

  statement {
    effect   = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:Encrypt"
    ]

    resources = [
      aws_kms_key.main.arn
    ]
  }

  statement {
    effect   = "Allow"

    actions = [
      "logs:*"
    ]

    resources = [
      "*"
    ]
  }

}

resource "aws_iam_policy" "glue_custom" {
  name        = "GlueCustom"
  path        = "/"

  policy = data.aws_iam_policy_document.glue_custom.json
}


resource "aws_iam_role" "glue" {
  name               = "GlueSecureServiceRole"
  assume_role_policy = data.aws_iam_policy_document.glue.json
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role       = aws_iam_role.glue.name
}

resource "aws_iam_role_policy_attachment" "glue_custom" {
  policy_arn = aws_iam_policy.glue_custom.arn
  role       = aws_iam_role.glue.name
}
