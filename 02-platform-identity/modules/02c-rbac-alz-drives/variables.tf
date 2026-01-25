# =============================================================================
# Variables
# =============================================================================

variable "principal_id" {
  description = "The object ID of the ALZ drives service principal"
  type        = string
}

variable "alz_drive_subscription_scope" {
  description = "The scope of the ALZ drive subscription"
  type        = string
}

variable "tfstate_storage_account_id" {
  description = "The ID of the Terraform state storage account"
  type        = string
}
