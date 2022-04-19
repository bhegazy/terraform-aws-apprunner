
resource "aws_apprunner_service" "this" {
  count = var.create ? 1 : 0

  service_name = var.service_name
  #  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  ## The source configuration for the application.
  source_configuration {
    ## Either code_repository or image_repository must be specified (but not both).
    ## Service From image source (docker)
    dynamic "image_repository" {
      for_each = var.image_repository
      content {
        image_identifier      = image_repository.value.image_identifier
        image_repository_type = image_repository.value.image_repository_type
        dynamic "image_configuration" {
          for_each = image_repository.value.image_configuration
          content {
            port                          = image_configuration.value.port
            runtime_environment_variables = image_configuration.value.runtime_environment_variables
            start_command                 = image_configuration.value.start_command
          }
        }
      }
    }
    auto_deployments_enabled = var.auto_deployments_enabled
    ## Service From Code Source (git)
    #    dynamic "code_repository" {
    #      for_each = var.code_repository
    #      content {
    #        code_configuration {
    #          configuration_source = code_repository.value.configuration_source
    #          dynamic "code_configuration_values" {
    #            for_each = var.code_configuration_values
    #            content {
    #              runtime       = code_configuration_values.value.runtime
    #              build_command = code_configuration_values.value.build_command
    #              port          = code_configuration_values.value.port
    #              start_command = code_configuration_values.value.start_command
    #            }
    #          }
    #        }
    #        repository_url = code_repository.value.repository_url
    #        source_code_version {
    #          type  = code_repository.value.source_code_version_type
    #          value = code_repository.value.source_code_version_value
    #        }
    #      }
    #    }
    ## access_role_arn required for only private ECR image repository type
    ## connection_arn required for GitHub code repository type
    #    dynamic "authentication_configuration" {
    #      for_each = var.authentication_configuration
    #      content {
    #        access_role_arn = authentication_configuration.value.access_role_arn
    #        connection_arn = aws_apprunner_connection.this.arn
    #      }
    #    }
  }
  ## Everything below is optional

  ## if App Runner will run On VPC
  #  dynamic "network_configuration"  {
  #    for_each = var.network_configuration
  #    content {
  #      egress_configuration {
  #        egress_type       = network_configuration.value.egress_type
  #        vpc_connector_arn = aws_apprunner_connection.this.arn
  #      }
  #    }
  #  }
  #  dynamic "encryption_configuration" {
  #    for_each = var.encryption_configuration
  #    content {
  #      kms_key = encryption_configuration.value.kms_key
  #    }
  #  }
  #  dynamic "health_check_configuration" {
  #    for_each = var.health_check_configuration
  #    content {
  #      healthy_threshold  = health_check_configuration.value.healthy_threshold
  #      unhealthy_threshold = health_check_configuration.value.unhealthy_threshold
  #      interval = health_check_configuration.value.interval
  #      path = health_check_configuration.value.path
  #      protocol = health_check_configuration.value.protocol
  #      timeout = health_check_configuration.value.timeout
  #    }
  #  }
  #  dynamic "instance_configuration" {
  #    for_each = var.instance_configuration
  #    content {
  #      instance_role_arn = instance_configuration.value.instance_role_arn
  #      cpu = instance_configuration.value.cpu
  #      memory = instance_configuration.value.memory
  #    }
  #  }
  tags = var.tags
}

#resource "aws_apprunner_auto_scaling_configuration_version" "this" {
#  for_each = var.auto_scaling_configuration_version
#  auto_scaling_configuration_name = aws_apprunner_auto_scaling_configuration.this.name
#  max_concurrency = auto_scaling_configuration_version.value.max_concurrency
#  max_size        = auto_scaling_configuration_version.value.max_size
#  min_size        = auto_scaling_configuration_version.value.min_size
#  tags = var.tags
#}
#
#resource "aws_apprunner_connection" "this" {
#  for_each = var.apprunner_connection
#  connection_name = apprunner_connection.value.connection_name
#  provider_type   = "GITHUB" ## only GITHUB provider type is supported
#  tags = var.tags
#}
#resource "aws_apprunner_vpc_connector" "this" {
#  for_each = var.apprunner_vpc_connector
#  vpc_connector_name = apprunner_vpc_connector.value.vpc_connector_name
#  security_groups    = apprunner_vpc_connector.value.security_groups
#  subnets            = apprunner_vpc_connector.value.subnets
#  tags = var.tags
#}
