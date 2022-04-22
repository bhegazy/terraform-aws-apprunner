variable "create" {
  description = "Controls if App Runner resources should be created"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "App Runner service name"
  type        = string
  default     = ""
}

variable "auto_deployments_enabled" {
  description = "Whether continuous integration from the source repository is enabled for the App Runner service. Defaults to true."
  type        = bool
  default     = true
}

variable "image_repository" {
  description = "Image Repository configuration block for the App Runner service. Either code_repository or image_repository must be specified (but not both)."
  type        = any
  default     = {}
}

variable "code_repository" {
  description = "Code Repository configuration block for the App Runner service. Either code_repository or image_repository must be specified (but not both)."
  type        = any
  default     = {}
}

variable "create_apprunner_connection" {
  description = "Whether to create apprunner connection or not"
  type        = bool
  default     = false
}

variable "service_source_type" {
  description = "The service source type, valid values are 'code' or 'image'"
  type        = string
  default     = "image"
  validation {
    condition     = contains(["image", "code"], var.service_source_type)
    error_message = "Valid values for var: service_source_type are (image, code)."
  }
}
variable "access_role_arn" {
  type        = string
  description = "The access role ARN to use for the App Runner service if the service_source_type is 'image' and image_repository_type is not 'ECR_PUBLIC'"
  default     = ""
}
variable "connection_arn" {
  type        = string
  description = "The connection ARN to use for the App Runner service if the service_source_type is 'code' and create_apprunner_connection is false"
  default     = ""
}
variable "image_repository_type" {
  type        = string
  description = "The type of the image repository. This reflects the repository provider and whether the repository is private or public. Defaults to ECR"
  default     = "ECR"
  validation {
    condition     = contains(["ECR", "ECR_PUBLIC"], var.image_repository_type)
    error_message = "Valid values for var: image_repository_type are (ECR, ECR_PUBLIC)."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
