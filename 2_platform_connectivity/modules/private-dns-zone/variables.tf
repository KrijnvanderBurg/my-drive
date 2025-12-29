# -----------------------------------------------------------------------------
# Private DNS Zone Module - Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the private DNS zone (e.g., privatelink.blob.core.windows.net)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DNS zone"
  type        = map(string)
}
