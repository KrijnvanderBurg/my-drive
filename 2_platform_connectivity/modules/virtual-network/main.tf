# -----------------------------------------------------------------------------
# Virtual Network Module
# Creates an Azure Virtual Network
# Naming: vnet-<workload>-<archetype>-<env>-<region>-<instance>
# -----------------------------------------------------------------------------

resource "azurerm_virtual_network" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}
