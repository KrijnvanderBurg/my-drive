resource "azurerm_resource_group" "this" {
  name     = "rg-drive-on-${var.environment}-${var.location_short}-01"
  location = var.location
  tags     = var.tags
}

resource "azurerm_management_lock" "resource_group" {
  name       = "lock-prevent-delete"
  scope      = azurerm_resource_group.this.id
  lock_level = "CanNotDelete"
  notes      = "Prevents accidental deletion of drive resource group"
}

resource "azurerm_storage_account" "this" {
  name                     = "dlsdriveon${var.environment}${var.location_short}01"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"

  # Enable hierarchical namespace for Data Lake Storage Gen2
  is_hns_enabled = true

  # Security hardening
  shared_access_key_enabled       = true
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

  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    ip_rules       = var.allowed_ips
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

resource "azurerm_management_lock" "storage_account" {
  name       = "lock-prevent-delete"
  scope      = azurerm_storage_account.this.id
  lock_level = "CanNotDelete"
  notes      = "Prevents accidental deletion of drive storage account"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "containers" {
  for_each = toset(var.containers)

  name               = each.value
  storage_account_id = azurerm_storage_account.this.id
}
