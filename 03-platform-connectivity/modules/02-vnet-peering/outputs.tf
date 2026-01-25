# =============================================================================
# VNet Peering Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the VNet peering"
  value       = azurerm_virtual_network_peering.this.id
}

output "name" {
  description = "Name of the VNet peering"
  value       = azurerm_virtual_network_peering.this.name
}
