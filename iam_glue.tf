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

resource "aws_iam_role" "glue" {
  name               = "GlueSecureServiceRole"
  assume_role_policy = data.aws_iam_policy_document.glue.json
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role = aws_iam_role.glue.name
}