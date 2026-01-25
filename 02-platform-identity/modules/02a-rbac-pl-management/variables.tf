# =============================================================================
# Variables
# =============================================================================

variable "principal_id" {
  description = "The object ID of the platform management service principal"
  type        = string
}

variable "tenant_root_management_group_id" {
  description = "The ID of the tenant root management group"
  type        = string
}

variable "tfstate_storage_account_id" {
  description = "The ID of the Terraform state storage account"
  type        = string
}
