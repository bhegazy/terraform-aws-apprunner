provider "aws" {
  region = local.region
}

locals {
  name   = "hello-app-runner"
  region = "eu-west-1"

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
  image_identifier         = "public.ecr.aws/aws-containers/hello-app-runner:latest"
  auto_deployments_enabled = false # Must set to false to disable auto deployment for ECR_PUBLIC type
}
