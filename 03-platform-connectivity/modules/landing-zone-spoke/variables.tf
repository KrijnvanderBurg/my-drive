# =============================================================================
# Landing Zone Spoke - Variables
# =============================================================================

variable "landing_zone_name" {
  description = "Name of the landing zone (e.g., 'drives')"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., 'dev', 'prod')"
  type        = string
}

variable "region" {
  description = "Region short code (e.g., 'weu', 'gwc')"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "hub_vnet_name" {
  description = "Hub VNet name"
  type        = string
}

variable "hub_vnet_id" {
  description = "Hub VNet ID"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Hub resource group name"
  type        = string
}

variable "private_dns_zones" {
  description = "Private DNS zones to link"
  type        = set(string)
}

variable "private_dns_resource_group_name" {
  description = "DNS zones resource group name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
