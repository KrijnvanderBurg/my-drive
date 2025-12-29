variable "tenant_id" {
  description = "Azure Tenant ID (GUID format)"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.tenant_id))
    error_message = "The tenant_id must be a valid GUID format (e.g., 12345678-1234-1234-1234-123456789012)."
  }
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
  description = "Subscription ID for the management subscription (pl-management-co-${var.environment}-gwc-01)"
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
