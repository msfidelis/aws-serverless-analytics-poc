resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "main" {
  name      = var.project_name
  on_create = base64encode(templatefile("${path.module}/sagemaker/setup/create.tpl", {}))
  on_start  = base64encode(templatefile("${path.module}/sagemaker/setup/start.tpl", {}))
}

resource "aws_sagemaker_notebook_instance" "main" {
  name                    = var.project_name
  role_arn                = aws_iam_role.notebook.arn
  instance_type           = var.sagemaker_instance_type

  default_code_repository = aws_sagemaker_code_repository.main.code_repository_name

  kms_key_id = aws_kms_key.main.id
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.main.name

  tags = {
    Name = "foo"
  }
}