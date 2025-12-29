# -----------------------------------------------------------------------------
# NSG Association Module - Variables
# -----------------------------------------------------------------------------

variable "subnet_id" {
  description = "The ID of the subnet to associate"
  type        = string
}

variable "network_security_group_id" {
  description = "The ID of the network security group to associate"
  type        = string
}
