# -----------------------------------------------------------------------------
# Virtual Network Module - Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "DNS servers for the virtual network"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the virtual network"
  type        = map(string)
}
