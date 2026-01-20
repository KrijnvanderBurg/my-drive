# =============================================================================
# Landing Zone Spoke
# =============================================================================

resource "azurerm_resource_group" "this" {
  name     = "rg-connectivity-${var.landing_zone_name}-${var.environment}-${var.region}-01"
  location = var.location

  tags = merge(var.tags, {
    landing_zone = var.landing_zone_name
  })
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.landing_zone_name}-on-${var.environment}-${var.region}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space

  tags = merge(var.tags, {
    landing_zone = var.landing_zone_name
  })
}

# Hub -> Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.hub

  name                      = "peer-hub-to-${var.landing_zone_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# Spoke -> Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.landing_zone_name}-to-hub"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

# DNS Links
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  provider = azurerm.hub
  for_each = var.private_dns_zones

  name                  = "link-${var.landing_zone_name}-${var.environment}-${var.region}"
  resource_group_name   = var.private_dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false

  tags = var.tags
}
