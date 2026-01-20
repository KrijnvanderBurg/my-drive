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

output "default_nsg_id" {
  description = "ID of the default NSG for workload subnets"
  value       = azurerm_network_security_group.default.id
}

output "default_nsg_name" {
  description = "Name of the default NSG for workload subnets"
  value       = azurerm_network_security_group.default.name
}

output "default_route_table_id" {
  description = "ID of the default route table for workload subnets"
  value       = azurerm_route_table.default.id
}

output "default_route_table_name" {
  description = "Name of the default route table for workload subnets"
  value       = azurerm_route_table.default.name
}
