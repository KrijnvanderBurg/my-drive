# =============================================================================
# Landing Zone
# =============================================================================
# Complete landing zone with Log Analytics, Spoke VNet, and Key Vault.
# Names are generated automatically by the module following naming conventions.
# =============================================================================

module "landing_zone" {
  source = "../../modules/01-base-package"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }

  # Naming inputs
  landing_zone   = local.landing_zone
  environment    = local.environment
  location_short = local.location_short

  # Core configuration
  location      = local.location
  address_space = [local.spoke_cidr]
  tenant_id     = local.tenant_id

  # Hub peering
  hub_vnet_id             = local.hub_vnet_id
  hub_vnet_name           = local.hub_vnet_name
  hub_resource_group_name = local.hub_resource_group_name

  # Subnets
  lz_managed_subnets      = local.lz_managed_subnets
  azure_reserved_subnets  = local.azure_reserved_subnets
  azure_delegated_subnets = local.azure_delegated_subnets

  tags = local.common_tags
}
