# =============================================================================
# Container Registry Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the Container Registry"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "Name of the Container Registry"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "Login server URL of the Container Registry"
  value       = azurerm_container_registry.this.login_server
}
