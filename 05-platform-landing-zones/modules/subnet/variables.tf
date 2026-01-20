# =============================================================================
# Subnet Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the VNet"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "location" {
  description = "Azure region for resources (NSG, Route Table)"
  type        = string
}

variable "service_endpoints" {
  description = "List of service endpoints for the subnet (e.g., Microsoft.Storage, Microsoft.KeyVault)"
  type        = list(string)
  default     = []
}

variable "default_nsg_id" {
  description = "ID of the default NSG from the spoke network to associate with the subnet"
  type        = string
}

variable "default_route_table_id" {
  description = "ID of the default route table from the spoke network to associate with the subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
