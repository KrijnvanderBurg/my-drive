# -----------------------------------------------------------------------------
# Resource Group Module
# Creates an Azure Resource Group
# Naming: rg-<workload>-<archetype>-<env>-<region>-<instance>
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
