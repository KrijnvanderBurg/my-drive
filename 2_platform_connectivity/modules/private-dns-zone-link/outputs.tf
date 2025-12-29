# -----------------------------------------------------------------------------
# Private DNS Zone Link Module - Outputs
# -----------------------------------------------------------------------------

output "id" {
  description = "The ID of the DNS zone link"
  value       = azurerm_private_dns_zone_virtual_network_link.this.id
}

output "name" {
  description = "The name of the DNS zone link"
  value       = azurerm_private_dns_zone_virtual_network_link.this.name
}
