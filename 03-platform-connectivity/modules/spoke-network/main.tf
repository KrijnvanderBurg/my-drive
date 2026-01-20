# =============================================================================
# Spoke Network Module
# =============================================================================
# Creates a spoke virtual network with peering to hub.
# Includes resource group, default NSG (zero-trust), route table, and DNS links.
# =============================================================================

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space

  tags = var.tags
}

# =============================================================================
# Default Network Security Group (Zero Trust)
# =============================================================================

resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.name}-default"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# =============================================================================
# Default Route Table
# =============================================================================

resource "azurerm_route_table" "default" {
  name                          = "rt-${var.name}-default"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false

  tags = var.tags
}

# =============================================================================
# Hub-to-Spoke Peering
# =============================================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count    = var.hub_vnet_name != null ? 1 : 0
  provider = azurerm.hub

  name                      = "peer-hub-to-${var.peering_name_suffix}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = var.hub_allow_gateway_transit
}

# =============================================================================
# Spoke-to-Hub Peering
# =============================================================================

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count = var.hub_vnet_id != null ? 1 : 0

  name                      = "peer-${var.peering_name_suffix}-to-hub"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = var.use_remote_gateways
}

# =============================================================================
# Private DNS Zone Links
# =============================================================================

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  provider = azurerm.hub
  for_each = var.private_dns_zones

  name                  = "link-${var.peering_name_suffix}"
  resource_group_name   = var.private_dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false

  tags = var.tags
}
