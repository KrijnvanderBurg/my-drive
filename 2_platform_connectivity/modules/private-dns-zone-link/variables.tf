# -----------------------------------------------------------------------------
# Private DNS Zone Link Module - Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the DNS zone link"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the DNS zone"
  type        = string
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the virtual network to link"
  type        = string
}

variable "registration_enabled" {
  description = "Enable auto-registration of VM DNS records"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the DNS zone link"
  type        = map(string)
}
