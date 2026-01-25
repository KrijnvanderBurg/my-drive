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

# Custom role for VNet peering only
resource "azurerm_role_definition" "vnet_peering_only" {
  name  = "VNet Peering Only - PLZ Drives"
  scope = var.hub_vnet_id

  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete"
    ]
    not_actions = []
  }

  assignable_scopes = [
    var.hub_vnet_id
  ]
}

resource "azurerm_role_assignment" "hub_vnet_peering" {
  scope              = var.hub_vnet_id
  role_definition_id = azurerm_role_definition.vnet_peering_only.role_definition_resource_id
  principal_id       = var.principal_id
}
