# =============================================================================
# Log Analytics Module
# =============================================================================
# Creates a dedicated resource group and Log Analytics workspace for
# centralized logging and monitoring in the landing zone.
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Group
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Log Analytics Workspace
# -----------------------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}
