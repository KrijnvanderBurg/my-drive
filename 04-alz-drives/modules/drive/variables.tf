variable "environment" {
  description = "The environment for the deployment (dev, test, accp, prod)"
  type        = string
}

variable "location_short" {
  description = "The short location_short code (e.g., na, weu, gwc)"
  type        = string
}

variable "location" {
  description = "The Azure location_short for the resources"
  type        = string
}

variable "allowed_ips" {
  description = "List of IP addresses or CIDR ranges allowed to access the storage account"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
}

variable "containers" {
  description = "List of container names to create in the storage account"
  type        = list(string)
  default     = []
}
