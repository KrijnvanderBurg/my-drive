# =============================================================================
# Storage Account Module
# =============================================================================
# Creates an Azure Storage Account with diagnostic settings.
# =============================================================================

resource "azurerm_storage_account" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = var.account_tier
  account_replication_type   = var.account_replication_type
  account_kind               = var.account_kind
  min_tls_version            = var.min_tls_version
  https_traffic_only_enabled = var.https_traffic_only_enabled

  tags = var.tags
}

# =============================================================================
# Diagnostic Settings - Storage Account
# =============================================================================

resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# =============================================================================
# Diagnostic Settings - Blob Service
# =============================================================================

resource "azurerm_monitor_diagnostic_setting" "blob" {
  name                       = "diag-${var.name}-blob"
  target_resource_id         = "${azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}
