output "application_id" {
  description = "The application (client) ID of the app registration"
  value       = azuread_application.this.id
}

output "client_id" {
  description = "The client ID for authentication"
  value       = azuread_application.this.client_id
}

output "object_id" {
  description = "The object ID of the service principal (used for RBAC assignments)"
  value       = azuread_service_principal.this.object_id
}

output "display_name" {
  description = "The display name of the service principal"
  value       = azuread_service_principal.this.display_name
}
