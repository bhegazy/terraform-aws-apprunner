resource "aws_apprunner_service" "this" {
  count = var.create ? 1 : 0

  service_name = var.service_name

  auto_scaling_configuration_arn = var.auto_scaling_configuration_arn

  tags = var.tags

  ## The source configuration for the application.
  ## Either code_repository or image_repository must be specified (but not both).

  ## Service From image source (image)
  dynamic "source_configuration" {
    for_each = var.service_source_type == "image" ? [1] : []
    content {
      auto_deployments_enabled = var.auto_deployments_enabled

      ## access_role_arn required for only ECR image repository type (Private ECR)
      dynamic "authentication_configuration" {
        for_each = var.image_repository_type == "ECR" ? [1] : []
        content {
          access_role_arn = var.image_access_role_arn
        }
      }

      image_repository {
        image_identifier      = var.image_identifier
        image_repository_type = var.image_repository_type
        dynamic "image_configuration" {
          for_each = var.image_configuration != null ? [var.image_configuration] : []
          content {
            port                          = lookup(image_configuration.value, "port", null)
            runtime_environment_variables = lookup(image_configuration.value, "runtime_environment_variables", null)
            start_command                 = lookup(image_configuration.value, "start_command", null)
          }
        }
      }
    }
  }
  ## Service From Code Source (git)
  dynamic "source_configuration" {
    for_each = var.service_source_type == "code" ? [1] : []
    content {
      auto_deployments_enabled = var.auto_deployments_enabled

      ## connection_arn required for code repository type
      authentication_configuration {
        connection_arn = var.code_connection_arn
      }

      code_repository {
        repository_url = var.code_repository_url
        source_code_version {
          type  = var.code_version_type
          value = var.code_version_value
        }
        code_configuration {
          configuration_source = var.code_configuration_source
          dynamic "code_configuration_values" {
            for_each = var.code_configuration_source != "REPOSITORY" && var.code_configuration_values != {} ? [var.code_configuration_values] : []
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

  dynamic "health_check_configuration" {
    for_each = var.health_check_configuration != null ? [var.health_check_configuration] : []
    content {
      healthy_threshold   = lookup(health_check_configuration.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check_configuration.value, "unhealthy_threshold", null)
      interval            = lookup(health_check_configuration.value, "interval", null)
      path                = lookup(health_check_configuration.value, "path", null)
      protocol            = lookup(health_check_configuration.value, "protocol", null)
      timeout             = lookup(health_check_configuration.value, "timeout", null)
    }
  }

  dynamic "instance_configuration" {
    for_each = var.instance_configuration != null ? [var.instance_configuration] : []
    content {
      instance_role_arn = lookup(instance_configuration.value, "instance_role_arn", null)
      cpu               = lookup(instance_configuration.value, "cpu", null)
      memory            = lookup(instance_configuration.value, "memory", null)
    }
  }

  ## Custom VPC
  network_configuration {
    egress_configuration {
      egress_type       = var.use_vpc ? "VPC" : "DEFAULT"
      vpc_connector_arn = var.use_vpc ? var.vpc_connector_arn : ""
    }
  }
  #  dynamic "encryption_configuration" {
  #    for_each = var.encryption_configuration
  #    content {
  #      kms_key = encryption_configuration.value.kms_key
  #    }
  #  }
}
