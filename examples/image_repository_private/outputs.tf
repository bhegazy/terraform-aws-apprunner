output "service_arn" {
  description = "The App Runner Service ARN"
  value       = module.image_repository_private.service_arn
}

output "service_url" {
  description = "The App Runner Service URL"
  value       = module.image_repository_private.service_url
}

output "service_status" {
  description = "The App Runner Service Status"
  value       = module.image_repository_private.service_status
}
