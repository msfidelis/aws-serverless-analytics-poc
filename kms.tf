resource "aws_kms_key" "main" {
  description             = "KMS for PoC"
}

resource "aws_iam_role" "glue_grant" {
  name = format("%s-iam-role-for-grant", var.project_name)

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
  name              = format("%s-grant-to-glue", var.project_name)
  key_id            = aws_kms_key.main.key_id
  grantee_principal = aws_iam_role.glue_grant.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}