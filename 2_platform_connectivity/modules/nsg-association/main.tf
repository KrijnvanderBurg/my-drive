# -----------------------------------------------------------------------------
# NSG Association Module
# Associates a Network Security Group with a Subnet
# -----------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = var.subnet_id
  network_security_group_id = var.network_security_group_id
}
