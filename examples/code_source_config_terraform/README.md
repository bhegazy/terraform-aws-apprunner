# Code Source Config in Terraform Example
Deployment example if you want to config the app within terraform, `code_configuration_source = "API"`.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_code_repository_source"></a> [code\_repository\_source](#module\_code\_repository\_source) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_apprunner_connection.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_connection) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | The App Runner Service ARN |
| <a name="output_service_status"></a> [service\_status](#output\_service\_status) | The App Runner Service Status |
| <a name="output_service_url"></a> [service\_url](#output\_service\_url) | The App Runner Service URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
