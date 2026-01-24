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

# module "spokes" {
#   source     = "../../modules/spoke-network"
#   for_each   = local.spoke_cidrs
#   depends_on = [module.hub]

#   name                = "vnet-${each.key}-co-${local.environment}-${local.region}-01"
#   resource_group_name = module.hub.resource_group_name
#   location            = local.location
#   address_space       = [each.value]

#   hub_vnet_id   = module.hub.id
#   hub_vnet_name = module.hub.name

#   tags = local.common_tags
# }

# =============================================================================
# Hub-to-Spoke Peering (platform spokes)
# =============================================================================

# resource "azurerm_virtual_network_peering" "hub_to_spoke" {
#   for_each   = module.spokes
#   depends_on = [module.spokes]

#   name                      = "peer-${module.hub.name}-to-${each.value.name}"
#   resource_group_name       = module.hub.resource_group_name
#   virtual_network_name      = module.hub.name
#   remote_virtual_network_id = each.value.id
#   allow_forwarded_traffic   = true
#   allow_gateway_transit     = true
# }

# =============================================================================
# Private DNS Zones
# =============================================================================
# DNS zones are centrally managed in West Europe (WEU) region
# This region consumes DNS via VNet link from WEU
# No local DNS zones are created to avoid namespace conflicts
