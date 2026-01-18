# =============================================================================
# NSG Flow Logs Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the flow log resource"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region (must match Network Watcher region)"
  type        = string
}

variable "network_security_group_id" {
  description = "ID of the NSG to enable flow logs for"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account for flow logs"
  type        = string
}

variable "retention_days" {
  description = "Number of days to retain flow logs (0 for indefinite)"
  type        = number
  default     = 30
}

variable "traffic_analytics_enabled" {
  description = "Enable Traffic Analytics (requires Log Analytics workspace)"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Traffic Analytics (required if enabled)"
  type        = string
  default     = null
}

variable "log_analytics_workspace_resource_id" {
  description = "Log Analytics workspace resource ID for Traffic Analytics (required if enabled)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
