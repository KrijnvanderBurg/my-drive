# =============================================================================
# Storage Account Module
# =============================================================================
# Creates a storage account with lifecycle management for automatic cleanup.
# Used for NSG flow logs storage.
# =============================================================================

resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  # Security settings
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true # Required for flow logs

  blob_properties {
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
  }

  tags = var.tags
}

# =============================================================================
# Lifecycle Management Policy
# =============================================================================
# Automatically delete old flow logs to control costs

resource "azurerm_storage_management_policy" "this" {
  storage_account_id = azurerm_storage_account.this.id

  rule {
    name    = "delete-old-flowlogs"
    enabled = true

    filters {
      prefix_match = ["insights-logs-networksecuritygroupflowevent"]
      blob_types   = ["blockBlob"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.lifecycle_delete_after_days
      }
    }
  }
}
