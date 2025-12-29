# -----------------------------------------------------------------------------
# Network Security Group Module - Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the network security group"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the network security group"
  type        = string
}

variable "security_rules" {
  description = "Map of security rules to create"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the network security group"
  type        = map(string)
}
