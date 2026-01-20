# =============================================================================
# West Europe (weu) - Main Configuration
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
# Private DNS Zones (CENTRALIZED - Global DNS Management)
# =============================================================================
# Best Practice: DNS zones created once in WEU, linked to all regional hubs
# Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale

module "private_dns" {
  source   = "../../modules/private-dns-zone"
  for_each = toset(local.private_dns_zones)

  name                = each.value
  resource_group_name = azurerm_resource_group.connectivity.name

  virtual_network_links = {
    hub-weu = local.hub_weu_id
    hub-gwc = local.hub_gwc_id
  }

  tags = merge(
    local.common_tags,
    {
      "dns-scope"  = "global"
      "managed-in" = "weu"
    }
  )
}

# =============================================================================
# Landing Zone: Drives - Spoke Network (deployed in LZ subscription)
# =============================================================================

module "lz_spoke_drives" {
  source = "../../modules/landing-zone-spoke"

  providers = {
    azurerm     = azurerm.plz_drives
    azurerm.hub = azurerm
  }

  landing_zone_name               = "drives"
  environment                     = local.environment
  region                          = local.region
  location                        = local.location
  address_space                   = local.lz_spoke_cidrs["drives"]
  hub_vnet_name                   = module.hub.name
  hub_vnet_id                     = module.hub.id
  hub_resource_group_name         = azurerm_resource_group.connectivity.name
  private_dns_zones               = toset(local.private_dns_zones)
  private_dns_resource_group_name = azurerm_resource_group.connectivity.name

  tags = local.common_tags
}
