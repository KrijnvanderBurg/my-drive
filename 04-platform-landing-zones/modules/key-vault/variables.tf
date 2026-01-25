# =============================================================================
# Key Vault Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location_short for the Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace for diagnostic settings"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
