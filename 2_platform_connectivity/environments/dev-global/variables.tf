# -----------------------------------------------------------------------------
# Variables - Global Connectivity
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
