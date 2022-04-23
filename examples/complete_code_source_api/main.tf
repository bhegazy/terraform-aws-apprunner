provider "aws" {
  region = local.region
}

locals {
  name   = "complete_code"
  region = "eu-west-1"
  tags = {
    Name = local.name
  }
}

data "aws_subnets" "selected" {
  filter {
    name   = "availabilityZone"
    values = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  }
}

data "aws_security_group" "selected" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

## Create KMS Key
resource "aws_kms_key" "apprunner" {
  description             = "KMS Key For APP Runner Service: ${local.name}"
  deletion_window_in_days = "7"
}

resource "aws_kms_alias" "apprunner" {
  target_key_id = aws_kms_key.apprunner.id
  name          = "alias/apprunner"
}

## Create Instance IAM Role
module "iam_role_s3_access" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4"

  create_role = true
  trusted_role_services = [
    "tasks.apprunner.amazonaws.com"
  ]
  role_requires_mfa = false
  role_name         = "apprunner-${local.name}-role"
  custom_role_policy_arns = [
    module.iam_s3_policy.arn
  ]
}

## Create IAM Policy for s3 access
module "iam_s3_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4"

  name        = "${local.name}-s3-policy"
  path        = "/"
  description = "example read s3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::terraform-aws-app-runner-example-bucket/*"
    }
  ]
}
EOF
}

resource "aws_apprunner_vpc_connector" "main" {
  vpc_connector_name = "${local.name}-vpc-connector"
  subnets            = toset(data.aws_subnets.selected.ids)
  security_groups    = [data.aws_security_group.selected.id]

}

resource "aws_apprunner_auto_scaling_configuration_version" "main" {
  auto_scaling_configuration_name = "${local.name}-as"
  max_concurrency                 = 50
  max_size                        = 10
  min_size                        = 2

  tags = local.tags
}

# Must complete the connection handshake in AWS App Runner Console while creating the resource.
# if terraform apply failed, please re run again after completing the connection handshake.
resource "aws_apprunner_connection" "main" {

  connection_name = "${local.name}-git-conn"
  provider_type   = "GITHUB" ## only GITHUB provider type is supported

  tags = local.tags
}

module "code_repository_source" {
  source = "../../"
  create = true

  service_name             = local.name
  tags                     = local.tags
  service_source_type      = "code"
  auto_deployments_enabled = true

  code_connection_arn       = aws_apprunner_connection.main.arn
  code_repository_url       = "https://github.com/bhegazy/apprunner-python-app"
  code_version_type         = "BRANCH"
  code_version_value        = "main"
  code_configuration_source = "API"
  code_configuration_values = {
    build_command = "pip install -r requirements.txt"
    port          = "8080"
    runtime       = "PYTHON_3"
    start_command = "python server.py"
    runtime_environment_variables = {
      PORT      = "8080"
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
    }
  }
  health_check_configuration = {
    healthy_threshold   = "1"
    unhealthy_threshold = "3"
    interval            = "3"
    path                = "/"
    protocol            = "TCP"
    timeout             = "2"
  }
  instance_configuration = {
    instance_role_arn = module.iam_role_s3_access.iam_role_arn
    cpu               = "1024"
    memory            = "2048"
  }
  vpc_connector_arn              = aws_apprunner_vpc_connector.main.arn
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.main.arn
  kms_key_arn                    = aws_kms_key.apprunner.arn
}
