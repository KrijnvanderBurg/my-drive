# -----------------------------------------------------------------------------
# Route Table Module - Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the route table"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the route table"
  type        = string
}

variable "routes" {
  description = "Map of routes to create"
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the route table"
  type        = map(string)
}
