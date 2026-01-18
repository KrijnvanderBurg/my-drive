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
# Storage Account for NSG Flow Logs
# =============================================================================

module "flowlogs_storage" {
  source = "../../modules/storage-account"

  name                        = "stflowlogs${local.environment}${local.region}01"
  resource_group_name         = azurerm_resource_group.connectivity.name
  location                    = local.location
  lifecycle_delete_after_days = 30

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
# Hub NSG Flow Logs
# =============================================================================

module "hub_flow_logs" {
  source   = "../../modules/nsg-flow-logs"
  for_each = module.hub.network_security_groups

  name                      = "flowlog-${each.value.name}"
  resource_group_name       = azurerm_resource_group.connectivity.name
  location                  = local.location
  network_security_group_id = each.value.id
  storage_account_id        = module.flowlogs_storage.id
  retention_days            = 30

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
# Spoke NSG Flow Logs
# =============================================================================

module "spoke_flow_logs" {
  source   = "../../modules/nsg-flow-logs"
  for_each = local.spoke_cidrs

  name                      = "flowlog-nsg-vnet-${each.key}-co-${local.environment}-${local.region}-01-default"
  resource_group_name       = azurerm_resource_group.connectivity.name
  location                  = local.location
  network_security_group_id = module.spoke[each.key].default_nsg_id
  storage_account_id        = module.flowlogs_storage.id
  retention_days            = 30

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

module "private_dns" {
  source   = "../../modules/private-dns-zone"
  for_each = toset(local.private_dns_zones)

  name                = each.value
  resource_group_name = azurerm_resource_group.connectivity.name

  # Link to hub VNet for DNS resolution
  virtual_network_links = {
    hub = module.hub.id
  }

  tags = local.common_tags
}
