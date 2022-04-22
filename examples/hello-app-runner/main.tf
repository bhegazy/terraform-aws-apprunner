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
  service_source_type      = "image"
  image_repository_type    = "ECR_PUBLIC"
  auto_deployments_enabled = false # Must set to false to disable auto deployment for ECR_PUBLIC type
  image_repository = {
    image_identifier = "public.ecr.aws/aws-containers/hello-app-runner:latest"
    image_configuration = {
      port = 8080
      #      start_command = ""
      #      runtime_environment_variables = {
      #        ENV_VAR_1 = "value1"
      #        ENV_VAR_2 = "value2"
      #      }
    }
  }
}
