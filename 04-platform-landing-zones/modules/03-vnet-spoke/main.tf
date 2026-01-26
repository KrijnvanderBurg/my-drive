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
# Peering
# =============================================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.connectivity

  name                      = "peer-${var.hub_vnet_name}-to-${var.name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.name}-to-${var.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}
