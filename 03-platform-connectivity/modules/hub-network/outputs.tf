# =============================================================================
# Hub Network Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.this.name
}

output "resource_group_name" {
  description = "Resource group name of the hub virtual network"
  value       = azurerm_virtual_network.this.resource_group_name
}

output "address_space" {
  description = "Address space of the hub virtual network"
  value       = azurerm_virtual_network.this.address_space
}

output "subnets" {
  description = "Map of subnet names to their IDs"
  value = merge(
    {
      for name, subnet in azurerm_subnet.azure : name => {
        id               = subnet.id
        name             = subnet.name
        address_prefixes = subnet.address_prefixes
      }
    },
    {
      for name, subnet in azurerm_subnet.managed : name => {
        id               = subnet.id
        name             = subnet.name
        address_prefixes = subnet.address_prefixes
      }
    }
  )
}

output "network_security_groups" {
  description = "Map of NSG names to their IDs"
  value = {
    for name, nsg in azurerm_network_security_group.this : name => {
      id   = nsg.id
      name = nsg.name
    }
  }
}

output "route_tables" {
  description = "Map of route table names to their IDs"
  value = {
    for name, rt in azurerm_route_table.this : name => {
      id   = rt.id
      name = rt.name
    }
  }
}
