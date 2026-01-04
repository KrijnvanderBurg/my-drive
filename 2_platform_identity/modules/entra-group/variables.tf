variable "display_name" {
  description = "The display name for the security group"
  type        = string
}

variable "description" {
  description = "The description for the security group"
  type        = string
}

variable "assignable_to_role" {
  description = "Whether the group can be assigned to an Entra ID role (cannot be changed after creation)"
  type        = bool
  default     = false
}
