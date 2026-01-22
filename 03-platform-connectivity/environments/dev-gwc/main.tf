# =============================================================================
# Germany West Central (gwc) - Main Configuration
# =============================================================================

# =============================================================================
# Hub Network
# =============================================================================

module "hub" {
  source = "../../modules/hub-network"

  name                = "vnet-hub-co-${local.environment}-${local.region}-01"
  resource_group_name = "rg-connectivity-on-${local.environment}-${local.region}-01"
  location            = local.location
  address_space       = [local.hub_cidr]
  azure_subnets       = local.hub_azure_subnets
  managed_subnets     = local.hub_managed_subnets

  tags = local.common_tags
}

# =============================================================================
# Spoke Networks
# =============================================================================

module "spoke" {
  source   = "../../modules/spoke-network"
  for_each = local.spoke_cidrs

  name                = "vnet-${each.key}-co-${local.environment}-${local.region}-01"
  resource_group_name = module.hub.resource_group_name
  location            = local.location
  address_space       = [each.value]

  hub_vnet_name           = module.hub.name
  hub_vnet_id             = module.hub.id
  hub_resource_group_name = module.hub.resource_group_name

  use_remote_gateways       = false
  hub_allow_gateway_transit = true
  private_dns_zones         = []

  tags = merge(
    local.common_tags,
    {}
  )
}


# =============================================================================
# Private DNS Zones
# =============================================================================
# DNS zones are centrally managed in West Europe (WEU) region
# This region consumes DNS via VNet link from WEU
# No local DNS zones are created to avoid namespace conflicts
