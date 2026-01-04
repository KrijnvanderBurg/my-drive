variable "environment" {
  description = "Environment name (dev, test, accp, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources that support tagging"
  type        = map(string)
}

variable "trusted_ips" {
  description = "List of trusted IP addresses or CIDR ranges for named location"
  type        = list(string)
  default     = ["192.168.1.1/32"]
}

variable "alert_email" {
  description = "Email address for identity security alerts"
  type        = string
  default     = "krijnvdburg@protonmail.com"
}
