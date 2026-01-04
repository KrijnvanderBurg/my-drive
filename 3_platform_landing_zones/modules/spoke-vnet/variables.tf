# -----------------------------------------------------------------------------
# Spoke VNet Module - Variables
# -----------------------------------------------------------------------------

variable "workload" {
  description = "Workload name for this spoke"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "Address space for the spoke VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
}

# Hub connectivity (from remote state)
variable "hub_vnet_id" {
  description = "ID of the hub VNet (from remote state)"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet (from remote state)"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group of the hub VNet (from remote state)"
  type        = string
}

variable "hub_route_table_id" {
  description = "ID of the hub route table to associate with spoke subnets (from remote state)"
  type        = string
}

variable "dns_resource_group_name" {
  description = "Resource group containing Private DNS zones (from remote state)"
  type        = string
}

variable "peering_name_spoke_to_hub" {
  description = "Name of the spoke-to-hub peering"
  type        = string
}

variable "peering_name_hub_to_spoke" {
  description = "Name of the hub-to-spoke peering"
  type        = string
}

variable "dns_zone_ids" {
  description = "Map of DNS zone names to link"
  type = map(object({
    zone_name = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
