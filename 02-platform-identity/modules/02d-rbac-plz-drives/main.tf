# =============================================================================
# RBAC Role Assignments - PLZ Drives SP
# =============================================================================

# Contributor for managing PLZ drive resources
resource "azurerm_role_assignment" "subscription_contributor" {
  scope                = var.plz_drives_subscription_scope
  role_definition_name = "Contributor"
  principal_id         = var.principal_id
}

# User Access Administrator for creating management locks
resource "azurerm_role_assignment" "subscription_uaa" {
  scope                = var.plz_drives_subscription_scope
  role_definition_name = "User Access Administrator"
  principal_id         = var.principal_id
}

# Storage Blob Data Contributor for Terraform state access
resource "azurerm_role_assignment" "tfstate" {
  scope                = var.tfstate_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.principal_id
}
