data "aws_iam_policy_document" "redshift" {
  
    version = "2012-10-17"

    statement {

        actions = [ "sts:AssumeRole" ]

        principals {
            type = "Service"
            identifiers = [
                "redshift.amazonaws.com"
            ]
        }

    }

}

resource "aws_iam_role" "redshift" {
    name = "RedshiftServiceRole"
    assume_role_policy = data.aws_iam_policy_document.redshift.json
}

resource "aws_iam_role_policy_attachment" "redshift_full" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
  role = aws_iam_role.redshift.name
}

resource "aws_iam_role_policy_attachment" "redshift_s3" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  role = aws_iam_role.redshift.name
}
