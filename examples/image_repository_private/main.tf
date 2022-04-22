provider "aws" {
  region = local.region
}

locals {
  name   = "image_repository_private"
  region = "us-east-1"

  tags = {
    Name = local.name
  }
}

resource "aws_iam_service_linked_role" "apprunner_ecr_role" {
  aws_service_name = "apprunner.amazonaws.com"
}

module "image_repository_private" {
  source = "../../"
  create = true

  service_name             = local.name
  tags                     = local.tags
  service_source_type      = "image"
  image_repository_type    = "ECR"
  access_role_arn          = aws_iam_service_linked_role.apprunner_ecr_role.arn
  auto_deployments_enabled = true
  image_identifier         = "091285508690.dkr.ecr.us-east-1.amazonaws.com/aws-app-runner-rust-example:latest"
  image_configuration = {
    port          = 8080
    start_command = "./aws-app-runner-rust-example"
    runtime_environment_variables = {
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
    }
  }
}
