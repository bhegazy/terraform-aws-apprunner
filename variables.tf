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
  default     = []
}
#variable "code_repository" {
#  description = "Code Repository configuration block for the App Runner service. Either code_repository or image_repository must be specified (but not both)."
#  type        = any
#  default     = {}
#}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
