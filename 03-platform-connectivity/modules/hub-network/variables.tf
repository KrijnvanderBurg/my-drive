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
  description = "Azure region for resources"
  type        = string
}

variable "address_space" {
  description = "Address space for the hub VNet (e.g., 10.1.0.0/20)"
  type        = string
}

variable "azure_subnets" {
  description = "Azure reserved subnets (GatewaySubnet, AzureFirewallSubnet, etc.) - no NSG/RT"
  type        = map(string)
  default     = {}
}

variable "managed_subnets" {
  description = "Platform managed subnets - get NSG and route table"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
