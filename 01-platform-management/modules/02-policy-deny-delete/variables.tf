variable "name" {
  description = "Short name identifier for the policy (used in resource names)"
  type        = string
}

variable "display_name" {
  description = "Display name for the policy (shown in Azure Portal)"
  type        = string
}

variable "management_group_id" {
  description = "The management group ID where the policy definition will be created"
  type        = string
}
