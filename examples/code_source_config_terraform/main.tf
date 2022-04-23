provider "aws" {
  region = local.region
}

locals {
  name   = "source_config_terraform"
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
}
