variable "name" {
  description = "Name of the spoke virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Name of the hub resource group for peering"
  type        = string
}

variable "hub_vnet_id" {
  description = "Hub VNet ID for peering"
  type        = string
}

variable "hub_vnet_name" {
  description = "Hub VNet name for peering reference"
  type        = string
}

variable "use_remote_gateways" {
  description = "Use hub's gateways for spoke traffic"
  type        = bool
  default     = false
}

variable "location" {
  description = "Azure location_short for resources"
  type        = string
}

variable "address_space" {
  description = "Address space for the spoke VNet (e.g., ['10.1.16.0/20'])"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# =============================================================================
# Subnet Configuration
# =============================================================================

variable "lz_managed_subnets" {
  description = "Landing zone managed subnets with NSG and route table enforcement (zero-trust by default)"
  type = map(object({
    address_prefix    = string
    service_endpoints = list(string)
  }))
  default = {}
}

variable "azure_reserved_subnets" {
  description = "Azure reserved subnets (GatewaySubnet, AzureFirewallSubnet, etc. - no NSG/route table)"
  type = map(object({
    address_prefix    = string
    service_endpoints = list(string)
  }))
  default = {}
}

variable "azure_delegated_subnets" {
  description = "Azure delegated subnets for services (App Service, Container Instances, etc. - no NSG/route table)"
  type = map(object({
    address_prefix    = string
    service_endpoints = list(string)
    delegation = object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })
  }))
  default = {}
}
