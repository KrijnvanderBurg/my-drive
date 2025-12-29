# -----------------------------------------------------------------------------
# VNet Peering Module - Outputs
# -----------------------------------------------------------------------------

output "source_to_destination_id" {
  description = "The ID of the source to destination peering"
  value       = azurerm_virtual_network_peering.source_to_destination.id
}

output "destination_to_source_id" {
  description = "The ID of the destination to source peering"
  value       = azurerm_virtual_network_peering.destination_to_source.id
}
