
locals {
}

resource "aws_apprunner_service" "this" {
  count = var.create ? 1 : 0

  service_name = var.service_name
  #  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  ## The source configuration for the application.
  source_configuration {
    auto_deployments_enabled = var.auto_deployments_enabled

    ## Either code_repository or image_repository must be specified (but not both).
    ## Service From image source (docker)
    dynamic "image_repository" {
      for_each = var.image_repository != null && var.service_source_type == "image" ? [var.image_repository] : []
      content {
        image_identifier      = lookup(image_repository.value, "image_identifier", null)
        image_repository_type = var.image_repository_type
        dynamic "image_configuration" {
          for_each = lookup(image_repository.value, "image_configuration", null) != null ? [
            image_repository.value.image_configuration
          ] : []
          content {
            port                          = lookup(image_configuration.value, "port", null)
            runtime_environment_variables = lookup(image_configuration.value, "runtime_environment_variables", null)
            start_command                 = lookup(image_configuration.value, "start_command", null)
          }
        }
      }
    }
    ## Service From Code Source (git)
    dynamic "code_repository" {
      for_each = var.code_repository != null && var.service_source_type == "code" ? [var.code_repository] : []
      content {
        repository_url = lookup(code_repository.value, "repository_url", null)
        source_code_version {
          type  = lookup(code_repository.value, "source_code_version_type", null)
          value = lookup(code_repository.value, "source_code_version_value", null)
        }
        dynamic "code_configuration" {
          for_each = lookup(code_repository.value, "code_configuration", null) != null ? [
            code_repository.value.code_configuration
          ] : []
          content {
            configuration_source = lookup(code_configuration.value, "configuration_source", null)
            dynamic "code_configuration_values" {
              for_each = lookup(code_configuration.value, "code_configuration_values", null) != null ? [
                code_configuration.value.code_configuration_values
              ] : []
              content {
                runtime                       = lookup(code_configuration_values.value, "runtime", null)
                build_command                 = lookup(code_configuration_values.value, "build_command", null)
                port                          = lookup(code_configuration_values.value, "port", null)
                start_command                 = lookup(code_configuration_values.value, "start_command", null)
                runtime_environment_variables = lookup(code_configuration_values.value, "runtime_environment_variables", null)
              }
            }
          }
        }
      }
    }
    ## access_role_arn required for only private ECR image repository type
    ## connection_arn required for GitHub code repository type
    dynamic "authentication_configuration" {
      for_each = var.service_source_type == "image" && var.image_repository_type != "ECR_PUBLIC" ? [1] : []
      content {
        access_role_arn = var.access_role_arn
      }
    }
    dynamic "authentication_configuration" {
      for_each = var.service_source_type == "code" ? [1] : []
      content {
        connection_arn = var.create_apprunner_connection ? aws_apprunner_connection.this[0].arn : var.connection_arn
      }
    }
  }
  ## Everything below is optional

  ## if App Runner will run On VPC
  #    dynamic "network_configuration"  {
  #      for_each = var.network_configuration != null ? [var.network_configuration] : []
  #      content {
  #        egress_configuration {
  #          egress_type       = network_configuration.value.egress_type
  #          vpc_connector_arn = aws_apprunner_connection.this.arn
  #        }
  #      }
  #    }
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
  tags       = var.tags
  depends_on = [aws_apprunner_connection.this]
}

## After creation, you must complete the authentication handshake using the App Runner console.
resource "aws_apprunner_connection" "this" {
  count = var.create && var.create_apprunner_connection && var.service_source_type == "code" ? 1 : 0

  connection_name = "${var.service_name}-git-connection"
  provider_type   = "GITHUB" ## only GITHUB provider type is supported

  tags = var.tags
}
