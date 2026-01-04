variable "pr_number" {
  description = "PR number for ephemeral deployments (empty for prod)"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "Azure Tenant ID (GUID format)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, accp, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "accp", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, accp, prod."
  }
}

variable "tags" {
  description = "Common tags to apply to all resources that support tagging"
  type        = map(string)
}
