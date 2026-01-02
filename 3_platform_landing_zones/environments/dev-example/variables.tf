# -----------------------------------------------------------------------------
# Variables - Example Landing Zone
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
  description = "Short name for region"
  type        = string
}

variable "workload" {
  description = "Workload name"
  type        = string
}

variable "archetype" {
  description = "Archetype (co=corp, on=online)"
  type        = string
}

variable "address_space" {
  description = "Address space for the spoke VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
