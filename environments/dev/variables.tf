variable "tenant_id" {
  description = "Azure Tenant ID (GUID format)"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.tenant_id))
    error_message = "The tenant_id must be a valid GUID format (e.g., 12345678-1234-1234-1234-123456789012)."
  }
}

variable "environment" {
  description = "Environment name (dev, tst, prd)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "accp", "prd"], var.environment)
    error_message = "Environment must be one of: dev, test, accp, prod."
  }
}

variable "tags" {
  description = "Common tags to apply to all resources that support tagging"
  type        = map(string)
}

variable "management_subscription_id" {
  description = "Subscription ID for the management subscription (sub-management-dev-gwc-01)"
  type        = string
}
