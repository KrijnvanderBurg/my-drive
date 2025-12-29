# -----------------------------------------------------------------------------
# Route Table Association Module - Outputs
# -----------------------------------------------------------------------------

output "id" {
  description = "The ID of the route table association"
  value       = azurerm_subnet_route_table_association.this.id
}
