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

variable "pl_management_subscription_id" {
  description = "Subscription ID for the management subscription"
  type        = string
}

# =============================================================================
# Billing Configuration (Microsoft Customer Agreement)
# =============================================================================
# Define multiple billing scopes for different subscriptions. Each key is a
# logical name you can reference when creating subscriptions.
# =============================================================================

variable "billing_scopes" {
  description = "Map of billing scopes for MCA subscription creation"
  type = map(object({
    billing_account_name = string
    billing_profile_name = string
    invoice_section_name = string
  }))
}
