# -----------------------------------------------------------------------------
# VNet Peering Module
# Creates bidirectional VNet peering between two virtual networks
# Naming: peer-<source>-to-<destination>-<archetype>-<env>-<region>-<instance>
# -----------------------------------------------------------------------------

resource "azurerm_virtual_network_peering" "source_to_destination" {
  name                         = var.peering_name_source_to_destination
  resource_group_name          = var.source_resource_group_name
  virtual_network_name         = var.source_virtual_network_name
  remote_virtual_network_id    = var.destination_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.source_allow_gateway_transit
  use_remote_gateways          = var.source_use_remote_gateways
}

resource "azurerm_virtual_network_peering" "destination_to_source" {
  name                         = var.peering_name_destination_to_source
  resource_group_name          = var.destination_resource_group_name
  virtual_network_name         = var.destination_virtual_network_name
  remote_virtual_network_id    = var.source_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.destination_allow_gateway_transit
  use_remote_gateways          = var.destination_use_remote_gateways
}
