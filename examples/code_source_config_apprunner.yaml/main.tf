provider "aws" {
  region = local.region
}

locals {
  name   = "source_config_repo"
  region = "eu-west-1"
  tags = {
    Name = local.name
  }
}

# Must complete the connection handshake in AWS App Runner Console while creating the resource.
# if terraform apply failed, please re run again after completing the connection handshake.
resource "aws_apprunner_connection" "main" {
  connection_name = "${local.name}-git-conn"
  provider_type   = "GITHUB" ## only GITHUB provider type is supported
  tags            = local.tags
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
  code_configuration_source = "REPOSITORY"
}
