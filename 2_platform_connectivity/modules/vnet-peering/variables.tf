# -----------------------------------------------------------------------------
# VNet Peering Module - Variables
# -----------------------------------------------------------------------------

variable "peering_name_source_to_destination" {
  description = "Name of the peering from source to destination"
  type        = string
}

variable "peering_name_destination_to_source" {
  description = "Name of the peering from destination to source"
  type        = string
}

variable "source_resource_group_name" {
  description = "Resource group name of the source virtual network"
  type        = string
}

variable "source_virtual_network_name" {
  description = "Name of the source virtual network"
  type        = string
}

variable "source_virtual_network_id" {
  description = "ID of the source virtual network"
  type        = string
}

variable "destination_resource_group_name" {
  description = "Resource group name of the destination virtual network"
  type        = string
}

variable "destination_virtual_network_name" {
  description = "Name of the destination virtual network"
  type        = string
}

variable "destination_virtual_network_id" {
  description = "ID of the destination virtual network"
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Allow virtual network access"
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic"
  type        = bool
  default     = true
}

variable "source_allow_gateway_transit" {
  description = "Allow gateway transit on source"
  type        = bool
  default     = false
}

variable "source_use_remote_gateways" {
  description = "Use remote gateways on source"
  type        = bool
  default     = false
}

variable "destination_allow_gateway_transit" {
  description = "Allow gateway transit on destination"
  type        = bool
  default     = false
}

variable "destination_use_remote_gateways" {
  description = "Use remote gateways on destination"
  type        = bool
  default     = false
}
