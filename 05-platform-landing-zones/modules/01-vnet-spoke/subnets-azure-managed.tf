# =============================================================================
# Azure Reserved Subnets
# =============================================================================
# Azure reserved subnet names (no NSG/route table per Azure requirements):
# - GatewaySubnet, AzureFirewallSubnet, AzureBastionSubnet, RouteServerSubnet, etc.
# =============================================================================

resource "azurerm_subnet" "azure_reserved" {
  for_each = var.azure_reserved_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints
}

# =============================================================================
# Azure Delegated Subnets
# =============================================================================
# Delegated to Azure services (App Service, Container Instances, etc.)
# No NSG or route table per Azure service delegation requirements
# =============================================================================

resource "azurerm_subnet" "azure_delegated" {
  for_each = var.azure_delegated_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  delegation {
    name = each.value.delegation.name

    service_delegation {
      name    = each.value.delegation.service_delegation.name
      actions = each.value.delegation.service_delegation.actions
    }
  }
}
