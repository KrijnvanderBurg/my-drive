# =============================================================================
# Storage Account Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the Storage Account"
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Name of the Storage Account"
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint of the Storage Account"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_file_endpoint" {
  description = "Primary file endpoint of the Storage Account"
  value       = azurerm_storage_account.this.primary_file_endpoint
}

output "primary_access_key" {
  description = "Primary access key of the Storage Account"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}
