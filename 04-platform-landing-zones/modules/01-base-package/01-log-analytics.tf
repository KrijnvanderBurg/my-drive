# =============================================================================
# Log Analytics Resources
# =============================================================================

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_in_days # 7-30 days for cost optimization

  # Daily ingestion cap in GB (prevents unexpected costs)
  daily_quota_gb = var.log_analytics_daily_quota_gb # e.g., 1, 5, 10 GB

  tags = var.tags
}

# =============================================================================
# Storage Account for Log Export (Long-term retention)
# =============================================================================

resource "azurerm_storage_account" "logs" {
  name                     = local.storage_account_logs_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Use LRS for cost savings
  account_kind             = "StorageV2"

  # Cost optimization: disable features not needed for log storage
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_container" "logs" {
  name                  = "law-export"
  storage_account_name  = azurerm_storage_account.logs.name
  container_access_type = "private"
}

# Lifecycle policy: Hot (30d) → Cool (90d) → Archive (indefinite)
resource "azurerm_storage_management_policy" "logs_lifecycle" {
  storage_account_id = azurerm_storage_account.logs.id

  rule {
    name    = "log-retention-policy"
    enabled = true

    filters {
      prefix_match = ["law-export/"]
      blob_types   = ["blockBlob"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30   # Move to cool after 30 days
        tier_to_archive_after_days_since_modification_greater_than = 120  # Archive after 120 days
        delete_after_days_since_modification_greater_than          = 2555 # Delete after 7 years (optional)
      }
    }
  }
}

# =============================================================================
# Log Analytics Data Export (Continuous export to Storage)
# =============================================================================

resource "azurerm_log_analytics_data_export_rule" "to_storage" {
  name                    = "export-to-storage"
  resource_group_name     = azurerm_resource_group.this.name
  workspace_resource_id   = azurerm_log_analytics_workspace.this.id
  destination_resource_id = azurerm_storage_account.logs.id
  table_names             = var.log_export_table_names # Selective tables only
  enabled                 = true

  depends_on = [azurerm_storage_container.logs]
}

# =============================================================================
# Basic Logs Configuration for High-Volume Tables
# =============================================================================
# Note: Basic Logs reduce ingestion costs by 50% but have limited query capabilities
# Configure via azurerm_log_analytics_workspace_table resource

resource "azurerm_log_analytics_workspace_table" "container_logs_basic" {
  count        = var.enable_basic_logs ? 1 : 0
  workspace_id = azurerm_log_analytics_workspace.this.id
  name         = "ContainerLogV2" # High-volume table
  plan         = "Basic"          # 50% cost reduction

  # Basic logs have fixed 8-day retention
  retention_in_days = 8
}

resource "azurerm_log_analytics_workspace_table" "syslog_basic" {
  count             = var.enable_basic_logs ? 1 : 0
  workspace_id      = azurerm_log_analytics_workspace.this.id
  name              = "Syslog"
  plan              = "Basic"
  retention_in_days = 8
}
