# =============================================================================
# Germany West Central (gwc) - Main Configuration
# =============================================================================

# =============================================================================
# Resource Group
# =============================================================================

resource "azurerm_resource_group" "connectivity" {
  name     = "rg-connectivity-on-${local.environment}-${local.region}-01"
  location = local.location

  tags = local.common_tags
}

# =============================================================================
# Hub Network
# =============================================================================

module "hub" {
  source = "../../modules/hub-network"

  name                = "vnet-hub-co-${local.environment}-${local.region}-01"
  resource_group_name = azurerm_resource_group.connectivity.name
  location            = local.location
  address_space       = local.hub_cidr
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
  resource_group_name = azurerm_resource_group.connectivity.name
  location            = local.location
  address_space       = each.value

  tags = local.common_tags
}

# =============================================================================
# Hub-to-Spoke Peerings
# =============================================================================

# Hub -> Spoke peerings
module "hub_to_spoke_peering" {
  source   = "../../modules/vnet-peering"
  for_each = local.spoke_cidrs

  name                      = "peer-hub-to-${each.key}"
  resource_group_name       = azurerm_resource_group.connectivity.name
  virtual_network_name      = module.hub.name
  remote_virtual_network_id = module.spoke[each.key].id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true # Hub can share gateway with spokes
}

# Spoke -> Hub peerings
module "spoke_to_hub_peering" {
  source   = "../../modules/vnet-peering"
  for_each = local.spoke_cidrs

  name                      = "peer-${each.key}-to-hub"
  resource_group_name       = azurerm_resource_group.connectivity.name
  virtual_network_name      = module.spoke[each.key].name
  remote_virtual_network_id = module.hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false # Enable when gateway is deployed
}

# =============================================================================
# Private DNS Zones
# =============================================================================
# DNS zones are centrally managed in West Europe (WEU) region
# This region consumes DNS via VNet link from WEU
# No local DNS zones are created to avoid namespace conflicts
