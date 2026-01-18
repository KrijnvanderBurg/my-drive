# =============================================================================
# Private DNS Zone Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the private DNS zone (e.g., privatelink.blob.core.windows.net)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_links" {
  description = "Map of VNet link name to VNet ID"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
