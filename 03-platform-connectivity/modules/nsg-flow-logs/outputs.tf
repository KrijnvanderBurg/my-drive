# =============================================================================
# NSG Flow Logs Module - Outputs
# =============================================================================

output "id" {
  description = "ID of the flow log resource"
  value       = azurerm_network_watcher_flow_log.this.id
}

output "name" {
  description = "Name of the flow log resource"
  value       = azurerm_network_watcher_flow_log.this.name
}
