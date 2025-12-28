output "id" {
  description = "The ID of the policy definition"
  value       = azurerm_policy_definition.deny_delete.id
}

output "name" {
  description = "The name of the policy definition"
  value       = azurerm_policy_definition.deny_delete.name
}
