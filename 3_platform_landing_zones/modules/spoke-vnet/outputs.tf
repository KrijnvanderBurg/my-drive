# -----------------------------------------------------------------------------
# Spoke VNet Module - Outputs
# -----------------------------------------------------------------------------

output "resource_group_id" {
  description = "ID of the spoke resource group"
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Name of the spoke resource group"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the spoke VNet"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the spoke VNet"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "route_table_id" {
  description = "ID of the route table"
  value       = azurerm_route_table.this.id
}
