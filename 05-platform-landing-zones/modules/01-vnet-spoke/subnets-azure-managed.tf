# =============================================================================
# Azure Managed Subnets (Delegated)
# =============================================================================
# Creates subnets with Azure service delegation:
# - Used for Azure services that require subnet delegation (App Service, Container Instances, etc.)
# - No NSG or route table attached per Azure service requirements
# - Supports service endpoints for secure access to Azure PaaS services
# =============================================================================

resource "azurerm_subnet" "azure_managed" {
  for_each = var.azure_managed_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  # Azure service delegation block
  delegation {
    name = each.value.delegation.name

    service_delegation {
      name    = each.value.delegation.service_delegation.name
      actions = each.value.delegation.service_delegation.actions
    }
  }
}
