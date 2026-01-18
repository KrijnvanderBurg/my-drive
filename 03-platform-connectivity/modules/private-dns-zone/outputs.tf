# =============================================================================
# Private DNS Zone Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the private DNS zone"
  value       = azurerm_private_dns_zone.this.id
}

output "name" {
  description = "Name of the private DNS zone"
  value       = azurerm_private_dns_zone.this.name
}

output "virtual_network_links" {
  description = "Map of VNet link names to their IDs"
  value = {
    for name, link in azurerm_private_dns_zone_virtual_network_link.this : name => {
      id   = link.id
      name = link.name
    }
  }
}
