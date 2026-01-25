output "id" {
  description = "ID of the spoke virtual network"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Name of the spoke virtual network"
  value       = azurerm_virtual_network.this.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Resource group name of the spoke virtual network"
  value       = azurerm_resource_group.this.name
}

output "address_space" {
  description = "Address space of the spoke virtual network"
  value       = azurerm_virtual_network.this.address_space
}

# =============================================================================
# Subnet Outputs
# =============================================================================

output "lz_managed_subnets" {
  description = "Landing zone managed subnets with NSG and route table"
  value = {
    for key, subnet in azurerm_subnet.lz_managed : key => {
      id             = subnet.id
      name           = subnet.name
      address_prefix = subnet.address_prefixes[0]
    }
  }
}

output "azure_managed_subnets" {
  description = "Azure managed subnets with delegation"
  value = {
    for key, subnet in azurerm_subnet.azure_managed : key => {
      id             = subnet.id
      name           = subnet.name
      address_prefix = subnet.address_prefixes[0]
    }
  }
}

output "nsgs" {
  description = "Network security groups for landing zone managed subnets"
  value = {
    for key, nsg in azurerm_network_security_group.lz_managed : key => {
      id   = nsg.id
      name = nsg.name
    }
  }
}

output "route_tables" {
  description = "Route tables for landing zone managed subnets"
  value = {
    for key, rt in azurerm_route_table.lz_managed : key => {
      id   = rt.id
      name = rt.name
    }
  }
}
