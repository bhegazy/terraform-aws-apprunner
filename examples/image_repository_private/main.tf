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

module "image_repository_private" {
  source = "../../"
  create = true

  service_name             = local.name
  tags                     = local.tags
  service_source_type      = "image"
  image_repository_type    = "ECR"
  access_role_arn          = "arn:aws:iam::091285508690:role/service-role/AppRunnerECRAccessRole"
  auto_deployments_enabled = true
  image_repository = {
    image_identifier = "091285508690.dkr.ecr.us-east-1.amazonaws.com/aws-app-runner-rust-example:latest"
    image_configuration = {
      port          = 8080
      start_command = "./aws-app-runner-rust-example"
      runtime_environment_variables = {
        ENV_VAR_1 = "value1"
        ENV_VAR_2 = "value2"
      }
    }
  }
}
