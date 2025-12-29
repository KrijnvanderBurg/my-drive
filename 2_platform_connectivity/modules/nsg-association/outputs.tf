# -----------------------------------------------------------------------------
# NSG Association Module - Outputs
# -----------------------------------------------------------------------------

output "id" {
  description = "The ID of the NSG association"
  value       = azurerm_subnet_network_security_group_association.this.id
}
