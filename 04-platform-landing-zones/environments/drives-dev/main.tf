# =============================================================================
# Log Analytics
# =============================================================================
# Centralized logging and monitoring workspace for the landing zone.
# =============================================================================

module "log_analytics" {
  source = "../../modules/01-log-analytics"

  name                = "law-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  resource_group_name = "rg-logs-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location            = local.location
  retention_in_days   = 30

  tags = local.common_tags
}

# =============================================================================
# Network Manager
# =============================================================================
# Network Manager with Verifier Workspace for landing zone connectivity testing.
# Verification intents are embedded in the vnet-spoke module.
# =============================================================================

module "network_manager" {
  source = "../../modules/02-network-manager"

  name                    = "nm-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  verifier_workspace_name = "vw-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  resource_group_name     = "rg-netmgr-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location                = local.location
  scope_subscription_ids  = ["/subscriptions/${local.subscription_id}"]

  tags = local.common_tags
}

# =============================================================================
# Spoke VNet
# =============================================================================
# Landing zone spoke virtual network with peering to hub and embedded
# network verification from app subnet to hub shared services.
# =============================================================================

module "vnet_spoke" {
  source = "../../modules/03-vnet-spoke"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  name                = "vnet-spoke-${local.landing_zone}-on-${local.environment}-${local.location_short}-01"
  resource_group_name = "rg-connectivity-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location            = local.location
  address_space       = [local.spoke_cidr]

  hub_vnet_id             = local.hub_vnet_id
  hub_vnet_name           = local.hub_vnet_name
  use_remote_gateways     = false # Set to true when gateways are deployed in the hub
  hub_resource_group_name = local.hub_resource_group_name

  lz_managed_subnets      = local.lz_managed_subnets
  azure_reserved_subnets  = local.azure_reserved_subnets
  azure_delegated_subnets = local.azure_delegated_subnets

  # Network verification configuration
  verifier_workspace_id           = module.network_manager.verifier_workspace_id
  verification_source_subnet_name = local.verification_source_subnet_name
  verification_destination_subnet = local.hub_subnets["snet-shared-services-co-${local.environment}-${local.location_short}-01"]

  tags = local.common_tags
}

# =============================================================================
# Key Vault
# =============================================================================

module "key_vault" {
  source = "../../modules/key-vault"

  name                       = "kv-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  resource_group_name        = "rg-security-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location                   = local.location
  tenant_id                  = local.tenant_id
  log_analytics_workspace_id = module.log_analytics.id

  tags = local.common_tags
}
