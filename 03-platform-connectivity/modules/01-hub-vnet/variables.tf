# =============================================================================
# Hub Network Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location_short for resources"
  type        = string
}

variable "address_space" {
  description = "Address space for the hub VNet"
  type        = list(string)
}

variable "azure_subnets" {
  description = "Azure-managed subnets configuration"
  type        = any
  default     = {}
}

variable "managed_subnets" {
  description = "Customer-managed subnets configuration"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
