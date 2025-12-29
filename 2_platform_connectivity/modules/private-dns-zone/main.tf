# -----------------------------------------------------------------------------
# Private DNS Zone Module
# Creates an Azure Private DNS Zone
# Naming: pdnsz-<service>-<domain>
# -----------------------------------------------------------------------------

resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
