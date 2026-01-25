# =============================================================================
# Storage Account Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the Storage Account (must be globally unique, lowercase alphanumeric, 3-24 chars)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location_short for the Storage Account"
  type        = string
}

variable "account_tier" {
  description = "Tier of the Storage Account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Kind of Storage Account (StorageV2, BlobStorage, etc.)"
  type        = string
  default     = "StorageV2"
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "https_traffic_only_enabled" {
  description = "Only allow HTTPS traffic"
  type        = bool
  default     = true
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
