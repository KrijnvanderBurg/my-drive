variable "tenant_id" {
  description = "Azure Tenant ID (GUID format)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, accp, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources that support tagging"
  type        = map(string)
}
