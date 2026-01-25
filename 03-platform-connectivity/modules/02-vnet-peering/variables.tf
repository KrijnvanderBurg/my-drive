# =============================================================================
# VNet Peering Module - Variables
# =============================================================================

variable "name" {
  description = "Name of the peering (from source perspective)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name of the source VNet"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the source virtual network"
  type        = string
}

variable "remote_virtual_network_id" {
  description = "ID of the remote virtual network to peer with"
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Allow access to the remote VNet"
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic from the remote VNet"
  type        = bool
  default     = true
}

variable "allow_gateway_transit" {
  description = "Allow gateway transit (set true on hub side)"
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "Use remote gateways (set true on spoke side when hub has gateway)"
  type        = bool
  default     = false
}
