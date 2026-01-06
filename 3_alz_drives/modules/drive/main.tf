resource "azurerm_resource_group" "this" {
  name     = "rg-drive-on-${var.environment}-${var.region}-01"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "this" {
  name                     = "dlsdriveon${var.environment}${var.region}01"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"

  # Enable hierarchical namespace for Data Lake Storage Gen2
  is_hns_enabled = true

  # Security hardening
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true

  # Disable all optional features
  blob_properties {
    versioning_enabled       = false
    change_feed_enabled      = false
    last_access_time_enabled = false

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  # Network restrictions - deny all by default, allow only whitelisted IPs
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.allowed_ips
  }

  tags = var.tags
}
