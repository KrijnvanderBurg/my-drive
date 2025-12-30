# -----------------------------------------------------------------------------
# Variables - Germany West Central Hub
# -----------------------------------------------------------------------------

variable "pr_number" {
  description = "PR number for ephemeral deployments (empty for prod)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "location_short" {
  description = "Short name for region (used in naming)"
  type        = string
}

variable "hub_address_space" {
  description = "Address space for hub VNet"
  type        = list(string)
}

variable "subnet_nva" {
  description = "NVA subnet CIDR"
  type        = string
}

variable "subnet_management" {
  description = "Management subnet CIDR"
  type        = string
}

variable "subnet_jumpbox" {
  description = "Jumpbox subnet CIDR"
  type        = string
}

variable "nva_primary_ip" {
  description = "Primary NVA private IP"
  type        = string
}

variable "nva_secondary_ip" {
  description = "Secondary NVA private IP"
  type        = string
}

variable "nva_lb_ip" {
  description = "NVA load balancer IP"
  type        = string
}

variable "identity_spoke_address_space" {
  description = "Address space for identity spoke VNet"
  type        = list(string)
}

variable "management_spoke_address_space" {
  description = "Address space for management spoke VNet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
