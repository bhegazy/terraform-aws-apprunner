output "service_arn" {
  description = "The App Runner Service ARN"
  value       = module.hello_app_runner.service_arn
}

output "service_url" {
  description = "The App Runner Service URL"
  value       = module.hello_app_runner.service_url
}

output "service_status" {
  description = "The App Runner Service Status"
  value       = module.hello_app_runner.service_status
}
