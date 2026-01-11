variable "environment" {
  description = "The environment for the deployment (dev, test, accp, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "allowed_ips" {
  description = "List of IP addresses or CIDR ranges allowed to access the storage account"
  type        = list(string)
  default     = []
  sensitive   = true
}
