# =============================================================================
# Subnet Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.this.id
}

output "name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.this.name
}

output "address_prefixes" {
  description = "Address prefixes of the subnet"
  value       = azurerm_subnet.this.address_prefixes
}
