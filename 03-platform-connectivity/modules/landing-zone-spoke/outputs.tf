# =============================================================================
# Landing Zone Spoke - Outputs
# =============================================================================

output "resource_group_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "VNet name"
  value       = azurerm_virtual_network.this.name
}
