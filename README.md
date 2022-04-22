# AWS App Runner Module
Terraform module which creates AWS AppRunner resources

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apprunner_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_connection) | resource |
| [aws_apprunner_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_role_arn"></a> [access\_role\_arn](#input\_access\_role\_arn) | The access role ARN to use for the App Runner service if the service\_source\_type is 'image' and image\_repository\_type is not 'ECR\_PUBLIC' | `string` | `""` | no |
| <a name="input_auto_deployments_enabled"></a> [auto\_deployments\_enabled](#input\_auto\_deployments\_enabled) | Whether continuous integration from the source repository is enabled for the App Runner service. Defaults to true. | `bool` | `true` | no |
| <a name="input_code_repository"></a> [code\_repository](#input\_code\_repository) | Code Repository configuration block for the App Runner service. Either code\_repository or image\_repository must be specified (but not both). | `any` | `{}` | no |
| <a name="input_connection_arn"></a> [connection\_arn](#input\_connection\_arn) | The connection ARN to use for the App Runner service if the service\_source\_type is 'code' and create\_apprunner\_connection is false | `string` | `""` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if App Runner resources should be created | `bool` | `true` | no |
| <a name="input_create_apprunner_connection"></a> [create\_apprunner\_connection](#input\_create\_apprunner\_connection) | Whether to create apprunner connection or not | `bool` | `false` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Image Repository configuration block for the App Runner service. Either code\_repository or image\_repository must be specified (but not both). | `any` | `{}` | no |
| <a name="input_image_repository_type"></a> [image\_repository\_type](#input\_image\_repository\_type) | The type of the image repository. This reflects the repository provider and whether the repository is private or public. Defaults to ECR | `string` | `"ECR"` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | App Runner service name | `string` | `""` | no |
| <a name="input_service_source_type"></a> [service\_source\_type](#input\_service\_source\_type) | The service source type, valid values are 'code' or 'image' | `string` | `"image"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | The App Runner Service ARN |
| <a name="output_service_status"></a> [service\_status](#output\_service\_status) | The App Runner Service Status |
| <a name="output_service_url"></a> [service\_url](#output\_service\_url) | The App Runner Service URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Bill Hegazy](https://github.com/bhegazy).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/bhegazy/terraform-aws-apprunner/tree/main/LICENSE) for full details
