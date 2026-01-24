# =============================================================================
# Hub Network
# =============================================================================

module "hub" {
  source = "../../modules/hub-vnet"

  name                = "vnet-hub-co-${local.environment}-${local.location_short}-01"
  resource_group_name = "rg-connectivity-on-${local.environment}-${local.location_short}-01"
  location            = local.location
  address_space       = [local.hub_cidr]
  azure_subnets       = local.hub_azure_subnets
  managed_subnets     = local.hub_managed_subnets

  tags = local.common_tags
}
