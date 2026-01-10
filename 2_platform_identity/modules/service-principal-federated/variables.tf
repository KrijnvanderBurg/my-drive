variable "name" {
  description = "Display name for the service principal and application"
  type        = string
}

variable "subjects" {
  description = "List of federation subjects for GitHub OIDC trust (e.g., 'repo:org/repo:ref:refs/heads/main')"
  type        = list(string)
}
