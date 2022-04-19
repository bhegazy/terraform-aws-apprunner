output "service_arn" {
  description = "The App Runner Service ARN"
  value       = try(aws_apprunner_service.this[0].arn, "")
}

output "service_url" {
  description = "The App Runner Service URL"
  value       = try(aws_apprunner_service.this[0].service_url, "")
}

output "service_status" {
  description = "The App Runner Service Status"
  value       = try(aws_apprunner_service.this[0].status, "")
}
