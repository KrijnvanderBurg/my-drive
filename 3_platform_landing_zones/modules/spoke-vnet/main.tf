# -----------------------------------------------------------------------------
# Spoke VNet Module
# Self-service module for landing zones to connect to hub
# Reads hub state, creates VNet, peering, routes, DNS links
# -----------------------------------------------------------------------------

# =============================================================================
# RESOURCE GROUP
# =============================================================================

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# =============================================================================
# VIRTUAL NETWORK
# =============================================================================

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags
}

# =============================================================================
# SUBNETS
# =============================================================================

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

# =============================================================================
# ROUTE TABLE (Default route to NVA)
# =============================================================================

resource "azurerm_route_table" "this" {
  name                = var.route_table_name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_route" "to_nva" {
  name                   = "to-internet-via-nva"
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.nva_lb_ip
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = azurerm_subnet.this

  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.this.id
}

# =============================================================================
# VNET PEERING TO HUB
# =============================================================================

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = var.peering_name_spoke_to_hub
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = var.peering_name_hub_to_spoke
  resource_group_name          = var.hub_resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

# =============================================================================
# DNS ZONE LINKS
# =============================================================================

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.dns_zone_ids

  name                  = "link-${var.workload}-${each.key}"
  resource_group_name   = var.hub_resource_group_name
  private_dns_zone_name = each.value.zone_name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}
