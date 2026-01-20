variable "name" {
  description = "Name of the spoke virtual network"
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
  description = "Address space for the spoke VNet (e.g., ['10.1.16.0/20'])"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "hub_vnet_name" {
  description = "Hub VNet name for peering"
  type        = string
  default     = null
}

variable "hub_vnet_id" {
  description = "Hub VNet ID for peering"
  type        = string
  default     = null
}

variable "hub_resource_group_name" {
  description = "Hub resource group name for peering"
  type        = string
  default     = null
}

variable "hub_allow_gateway_transit" {
  description = "Allow hub to share gateway with spoke"
  type        = bool
  default     = true
}

variable "use_remote_gateways" {
  description = "Use hub's gateways for spoke traffic"
  type        = bool
  default     = false
}

variable "peering_name_suffix" {
  description = "Suffix for peering names (defaults to VNet name without prefix)"
  type        = string
  default     = null
}

variable "private_dns_zones" {
  description = "Private DNS zones to link to this VNet"
  type        = set(string)
  default     = []
}

variable "private_dns_resource_group_name" {
  description = "Resource group name where DNS zones are located"
  type        = string
  default     = null
}
