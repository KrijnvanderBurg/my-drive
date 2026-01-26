# =============================================================================
# Network Manager Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the Network Manager"
  type        = string
}

variable "verifier_workspace_name" {
  description = "Name of the Verifier Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location for the Network Manager"
  type        = string
}

variable "scope_subscription_ids" {
  description = "List of subscription IDs for Network Manager scope (landing zone subscription only)"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
