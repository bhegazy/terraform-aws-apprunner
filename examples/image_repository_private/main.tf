provider "aws" {
  region = local.region
}

provider "time" {}

locals {
  name   = "image_repository_private"
  region = "eu-west-1"

  tags = {
    Name = local.name
  }
}
# create IAM ECR Access Role
module "image_repository_private_ecr_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4"

  create_role = true
  trusted_role_services = [
    "build.apprunner.amazonaws.com"
  ]
  role_requires_mfa = false
  role_name         = "apprunner-ecr-${local.name}"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess",
  ]
}

# wait 10s for iam role to be safely created
resource "time_sleep" "wait_role" {
  depends_on      = [module.image_repository_private_ecr_role]
  create_duration = "10s"
}
# Create App Runner Service
module "image_repository_private" {
  source = "../../"
  create = true

  service_name             = local.name
  tags                     = local.tags
  service_source_type      = "image"
  auto_deployments_enabled = true
  image_repository_type    = "ECR"
  image_access_role_arn    = module.image_repository_private_ecr_role.iam_role_arn
  image_identifier         = "091285508690.dkr.ecr.us-east-1.amazonaws.com/aws-app-runner-rust-example:latest"
  #  image_configuration      = {
  #    port                          = 8080
  #    start_command                 = "./aws-app-runner-rust-example"
  #    runtime_environment_variables = {
  #      ENV_VAR_1 = "value1"
  #      ENV_VAR_2 = "value2"
  #    }
  #  }
  depends_on = [
    time_sleep.wait_role
  ]
}
