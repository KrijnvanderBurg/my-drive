# =============================================================================
# Landing Zone Module
# =============================================================================
# Creates a complete landing zone including:
# - Log Analytics workspace for centralized logging
# - Spoke VNet with peering to hub
# - Key Vault with RBAC authorization and diagnostic settings
# =============================================================================

# =============================================================================
# Local Computed Names
# =============================================================================

locals {
  name_prefix = "${var.landing_zone}-${var.environment}-${var.location_short}"

  # Resource names following naming convention
  log_analytics_name                = "law-${local.name_prefix}-01"
  log_analytics_resource_group_name = "rg-logs-${local.name_prefix}-01"

  key_vault_name                = "kv-${local.name_prefix}-01"
  key_vault_resource_group_name = "rg-security-${local.name_prefix}-01"

  vnet_name           = "vnet-spoke-${local.name_prefix}-01"
  resource_group_name = "rg-connectivity-${local.name_prefix}-01"
}

# =============================================================================
# Log Analytics Resources
# =============================================================================

resource "azurerm_resource_group" "logs" {
  name     = local.log_analytics_resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_name
  resource_group_name = azurerm_resource_group.logs.name
  location            = azurerm_resource_group.logs.location
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_in_days

  tags = var.tags
}

# =============================================================================
# Spoke Network Resources
# =============================================================================

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space

  tags = var.tags
}

# =============================================================================
# Peering
# =============================================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.connectivity

  name                      = "peer-${var.hub_vnet_name}-to-${local.vnet_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${local.vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}



# =============================================================================
# Key Vault Resources
# =============================================================================

resource "azurerm_resource_group" "key_vault" {
  name     = local.key_vault_resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  name                          = local.key_vault_name
  resource_group_name           = azurerm_resource_group.key_vault.name
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
# Key Vault Diagnostic Settings
# =============================================================================

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
