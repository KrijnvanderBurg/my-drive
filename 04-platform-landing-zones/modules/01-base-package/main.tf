# =============================================================================
# Landing Zone Module
# =============================================================================
# Creates a complete landing zone including:
# - Log Analytics workspace for centralized logging
# - Spoke VNet with peering to hub
# - Key Vault with RBAC authorization and diagnostic settings
# =============================================================================

locals {
  resource_group_name = "rg-connectivity-${var.landing_zone}-${var.environment}-${var.location_short}-01"
  log_analytics_name  = "law-${var.landing_zone}-${var.environment}-${var.location_short}-01"
  key_vault_name      = "kv-${var.landing_zone}-${var.environment}-${var.location_short}-01"
  vnet_name           = "vnet-spoke-${var.landing_zone}-${var.environment}-${var.location_short}-01"

  # Storage account name: lowercase, no hyphens, 3-24 chars
  storage_account_logs_name = replace(lower("st${var.landing_zone}logs${var.environment}${var.location_short}"), "-", "")
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location

  tags = var.tags
}

# 01-log-analytics
# 02a-spoke-vnet
# 02b-keyvault
