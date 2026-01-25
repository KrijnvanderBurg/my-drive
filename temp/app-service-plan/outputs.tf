# =============================================================================
# App Service Plan Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.this.id
}

output "name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.this.name
}

output "kind" {
  description = "Kind of the App Service Plan"
  value       = azurerm_service_plan.this.kind
}
