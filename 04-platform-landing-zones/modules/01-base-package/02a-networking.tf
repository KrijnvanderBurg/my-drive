# =============================================================================
# Spoke Network Resources
# =============================================================================

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space

  tags = var.tags
}

# =============================================================================
# Peering
# =============================================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.connectivity

  name                      = "peer-${var.hub_vnet_name}-to-${local.vnet_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${local.vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

# =============================================================================
# Landing Zone Managed Subnets
# =============================================================================
# Creates subnets with zero-trust security model:
# - Each subnet has dedicated NSG with deny-all rules (priority 4096)
# - Each subnet has dedicated route table with BGP propagation disabled
# - Spoke owners must explicitly allow traffic with custom rules (priority < 4096)
# =============================================================================

# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------

resource "azurerm_subnet" "lz_managed" {
  for_each = var.lz_managed_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints
}

# -----------------------------------------------------------------------------
# Network Security Groups (Zero-Trust: Deny All by Default)
# -----------------------------------------------------------------------------

resource "azurerm_network_security_group" "lz_managed" {
  for_each = var.lz_managed_subnets

  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  # Zero-trust: Deny all inbound traffic by default
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Zero-trust: Deny all outbound traffic by default
  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "lz_managed" {
  for_each = var.lz_managed_subnets

  subnet_id                 = azurerm_subnet.lz_managed[each.key].id
  network_security_group_id = azurerm_network_security_group.lz_managed[each.key].id
}

resource "azurerm_monitor_diagnostic_setting" "vnet" {
  name                       = "diag-${local.vnet_name}"
  target_resource_id         = azurerm_virtual_network.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  for_each = var.lz_managed_subnets

  name                       = "diag-nsg-${each.key}"
  target_resource_id         = azurerm_network_security_group.lz_managed[each.key].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

# -----------------------------------------------------------------------------
# Route Tables (Explicit Route Control)
# -----------------------------------------------------------------------------

resource "azurerm_route_table" "lz_managed" {
  for_each = var.lz_managed_subnets

  name                          = "rt-${each.key}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false # Explicit route control

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "lz_managed" {
  for_each = var.lz_managed_subnets

  subnet_id      = azurerm_subnet.lz_managed[each.key].id
  route_table_id = azurerm_route_table.lz_managed[each.key].id
}

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
