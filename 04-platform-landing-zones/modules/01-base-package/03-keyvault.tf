
# =============================================================================
# Key Vault Resources
# =============================================================================

resource "azurerm_key_vault" "this" {
  name                          = local.key_vault_name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 30
  purge_protection_enabled      = true
  rbac_authorization_enabled    = true
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-${local.key_vault_name}"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
