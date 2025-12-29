# -----------------------------------------------------------------------------
# Route Table Association Module - Variables
# -----------------------------------------------------------------------------

variable "subnet_id" {
  description = "The ID of the subnet to associate"
  type        = string
}

variable "route_table_id" {
  description = "The ID of the route table to associate"
  type        = string
}
