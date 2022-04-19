provider "aws" {
  region = local.region
}

locals {
  name   = "hello-app-runner"
  region = "us-east-1"

  tags = {
    Name = local.name
  }
}

module "hello_app_runner" {
  source = "../../"
  create = true

  service_name             = local.name
  tags                     = local.tags
  auto_deployments_enabled = false # Must set to false to disable auto deployment for EC_PUBLIC type
  image_repository = [{
    image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
    image_repository_type = "ECR_PUBLIC"
    image_configuration = [{
      port          = 8000
      start_command = ""
      runtime_environment_variables = {
        ENV_VAR_1 = "value1"
        ENV_VAR_2 = "value2"
      }
    }]
  }]
}
