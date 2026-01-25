# =============================================================================
# Key Vault Module
# =============================================================================
# Creates an Azure Key Vault with RBAC authorization and diagnostic settings.
# =============================================================================

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  name                          = var.name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  rbac_authorization_enabled    = true
  public_network_access_enabled = false

  tags = var.tags
}

# =============================================================================
# Diagnostic Settings
# =============================================================================

# resource "azurerm_monitor_diagnostic_setting" "this" {
#   name                       = "diag-${var.name}"
#   target_resource_id         = azurerm_key_vault.this.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   enabled_log {
#     category = "AuditEvent"
#   }

#   enabled_log {
#     category = "AzurePolicyEvaluationDetails"
#   }

#   enabled_metric {
#     category = "AllMetrics"
#   }
# }
