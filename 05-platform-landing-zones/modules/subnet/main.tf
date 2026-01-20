# =============================================================================
# Subnet Module
# =============================================================================
# Creates a subnet within an existing VNet with NSG and route table associations.
# Uses the default NSG and route table from the spoke network (zero-trust).
# =============================================================================

resource "azurerm_subnet" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = var.service_endpoints
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = var.default_nsg_id
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = azurerm_subnet.this.id
  route_table_id = var.default_route_table_id
}
