# =============================================================================
# Hub Network Outputs
# =============================================================================

output "hub" {
  description = "Hub VNet details"
  value = {
    id                  = module.hub.id
    name                = module.hub.name
    resource_group_name = azurerm_resource_group.connectivity.name
    address_space       = module.hub.address_space
  }
}

output "resource_group" {
  description = "Connectivity resource group"
  value = {
    name     = azurerm_resource_group.connectivity.name
    location = azurerm_resource_group.connectivity.location
    id       = azurerm_resource_group.connectivity.id
  }
}

output "spoke_networks" {
  description = "Spoke VNet details"
  value = {
    for key, spoke in module.spoke : key => {
      id            = spoke.id
      name          = spoke.name
      address_space = spoke.address_space
    }
  }
}

output "private_dns_zones" {
  description = "Centralized Private DNS zones (managed in WEU)"
  value = {
    for zone_name, zone in module.private_dns : zone_name => {
      id                  = zone.id
      name                = zone.name
      resource_group_name = azurerm_resource_group.connectivity.name
    }
  }
}