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

# -----------------------------------------------------------------------------
# NSG Associations
# -----------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "lz_managed" {
  for_each = var.lz_managed_subnets

  subnet_id                 = azurerm_subnet.lz_managed[each.key].id
  network_security_group_id = azurerm_network_security_group.lz_managed[each.key].id
}

# -----------------------------------------------------------------------------
# Route Table Associations
# -----------------------------------------------------------------------------

resource "azurerm_subnet_route_table_association" "lz_managed" {
  for_each = var.lz_managed_subnets

  subnet_id      = azurerm_subnet.lz_managed[each.key].id
  route_table_id = azurerm_route_table.lz_managed[each.key].id
}
