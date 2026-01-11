output "id" {
  description = "The fully qualified ID of the management group"
  value       = azurerm_management_group.this.id
}

output "name" {
  description = "The name (ID) of the management group"
  value       = azurerm_management_group.this.name
}

output "display_name" {
  description = "The display name of the management group"
  value       = azurerm_management_group.this.display_name
}

output "parent_management_group_id" {
  description = "The ID of the parent management group"
  value       = azurerm_management_group.this.parent_management_group_id
}

output "subscription_ids" {
  description = "List of subscription IDs associated with this management group"
  value       = azurerm_management_group.this.subscription_ids
}
