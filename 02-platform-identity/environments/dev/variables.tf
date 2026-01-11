variable "environment" {
  description = "Environment name (dev, test, accp, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources that support tagging"
  type        = map(string)
}

variable "alert_email" {
  description = "Email address for identity security alerts"
  type        = string
  default     = "krijnvdburg@protonmail.com"
}
