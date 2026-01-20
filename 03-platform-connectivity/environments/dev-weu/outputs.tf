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

# =============================================================================
# Landing Zone Spoke Outputs
# =============================================================================

output "lz_drives_spoke" {
  description = "Drives landing zone spoke VNet details"
  value = {
    id                     = module.spoke_drives.id
    name                   = module.spoke_drives.name
    address_space          = module.spoke_drives.address_space
    resource_group_name    = azurerm_resource_group.lz_drives.name
    default_nsg_id         = module.spoke_drives.default_nsg_id
    default_route_table_id = module.spoke_drives.default_route_table_id
  }
}
