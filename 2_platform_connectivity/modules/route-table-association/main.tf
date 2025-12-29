# -----------------------------------------------------------------------------
# Route Table Association Module
# Associates a Route Table with a Subnet
# -----------------------------------------------------------------------------

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
}
