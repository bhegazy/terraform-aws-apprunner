output "service_arn" {
  description = "The App Runner Service ARN"
  value       = module.code_repository_source.service_arn
}

output "service_url" {
  description = "The App Runner Service URL"
  value       = module.code_repository_source.service_url
}

output "service_status" {
  description = "The App Runner Service Status"
  value       = module.code_repository_source.service_status
}
