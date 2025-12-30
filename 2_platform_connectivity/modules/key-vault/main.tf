# -----------------------------------------------------------------------------
# Key Vault Module
# Creates an Azure Key Vault for storing secrets
# Naming: kv-<archetype>-<env>-<region>-<instance>
# -----------------------------------------------------------------------------

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled
  tags                       = var.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = var.network_acls_default_action
  }
}

# Grant deployment identity access to manage secrets
resource "azurerm_key_vault_access_policy" "deployment" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover"
  ]
}
