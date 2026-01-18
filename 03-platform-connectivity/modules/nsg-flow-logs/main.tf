# =============================================================================
# NSG Flow Logs Module
# =============================================================================
# Enables flow logs on an NSG for network traffic monitoring.
# Logs are stored in a storage account with automatic retention.
# =============================================================================

# Network Watcher Resource Group
resource "azurerm_resource_group" "network_watcher" {
  name     = "NetworkWatcherRG"
  location = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

# Network Watcher - create if it doesn't exist
resource "azurerm_network_watcher" "this" {
  name                = "NetworkWatcher_${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.network_watcher.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_watcher_flow_log" "this" {
  name                 = var.name
  network_watcher_name = azurerm_network_watcher.this.name
  resource_group_name  = azurerm_network_watcher.this.resource_group_name
  location             = var.location

  target_resource_id = var.network_security_group_id
  storage_account_id = var.storage_account_id
  enabled            = true
  version            = 2

  retention_policy {
    enabled = var.retention_days > 0
    days    = var.retention_days
  }

  dynamic "traffic_analytics" {
    for_each = var.traffic_analytics_enabled ? [1] : []
    content {
      enabled               = true
      workspace_id          = var.log_analytics_workspace_id
      workspace_region      = var.location
      workspace_resource_id = var.log_analytics_workspace_resource_id
      interval_in_minutes   = 10
    }
  }

  tags = var.tags
}
