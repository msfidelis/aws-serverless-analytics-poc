resource "aws_kms_key" "main" {
  description             = "KMS for PoC"
}

resource "aws_iam_role" "glue_grant" {
  name = "iam-role-for-grant"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kms_grant" "glue_grant" {
  name              = "grant-to-glue"
  key_id            = aws_kms_key.main.key_id
  grantee_principal = aws_iam_role.glue_grant.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}