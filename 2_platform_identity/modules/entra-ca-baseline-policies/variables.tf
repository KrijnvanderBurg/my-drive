variable "policy_state" {
  description = "The state for all baseline policies (enabled, disabled, enabledForReportingButNotEnforced)"
  type        = string
  default     = "enabledForReportingButNotEnforced"

  validation {
    condition     = contains(["enabled", "disabled", "enabledForReportingButNotEnforced"], var.policy_state)
    error_message = "State must be one of: enabled, disabled, enabledForReportingButNotEnforced."
  }
}

variable "excluded_groups" {
  description = "List of group object IDs to exclude from all baseline policies (e.g., break-glass group)"
  type        = list(string)
  default     = []
}
