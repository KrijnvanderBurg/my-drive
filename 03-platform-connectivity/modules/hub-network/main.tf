# =============================================================================
# Hub Network Module
# =============================================================================
# Creates a hub virtual network with Azure and managed subnets.
# =============================================================================

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  depends_on = [azurerm_resource_group.this]

  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space

  tags = var.tags
}

# =============================================================================
# Azure Reserved Subnets (no NSG/RT - Azure requirement)
# =============================================================================

resource "azurerm_subnet" "azure" {
  depends_on = [azurerm_virtual_network.this]
  for_each   = var.azure_subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
}

# =============================================================================
# Managed Subnets (with NSG and Route Table)
# =============================================================================

resource "azurerm_subnet" "managed" {
  depends_on = [azurerm_virtual_network.this]
  for_each   = var.managed_subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
}

# =============================================================================
# Network Security Groups (Zero Trust - deny all by default)
# =============================================================================

resource "azurerm_network_security_group" "this" {
  for_each = var.managed_subnets

  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

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

resource "azurerm_subnet_network_security_group_association" "this" {
  depends_on = [azurerm_network_security_group.this, azurerm_subnet.managed]
  for_each   = var.managed_subnets

  subnet_id                 = azurerm_subnet.managed[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# =============================================================================
# Route Tables (empty - add NVA routes when needed)
# =============================================================================

resource "azurerm_route_table" "this" {
  for_each = var.managed_subnets

  name                          = "rt-${each.key}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = false

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "this" {
  depends_on = [azurerm_route_table.this, azurerm_subnet.managed]
  for_each   = var.managed_subnets

  subnet_id      = azurerm_subnet.managed[each.key].id
  route_table_id = azurerm_route_table.this[each.key].id
}
