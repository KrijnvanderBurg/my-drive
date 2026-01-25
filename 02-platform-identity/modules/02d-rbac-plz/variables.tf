# =============================================================================
# Variables
# =============================================================================

variable "principal_id" {
  description = "The object ID of the PLZ drives service principal"
  type        = string
}

variable "plz_drives_subscription_scope" {
  description = "The scope of the PLZ drives subscription"
  type        = string
}

variable "tfstate_storage_account_id" {
  description = "The ID of the Terraform state storage account"
  type        = string
}
