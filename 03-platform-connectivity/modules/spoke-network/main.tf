# =============================================================================
# Spoke Network Module
# =============================================================================
# Creates a spoke virtual network with no subnets.
# Subnets are created by workload teams in their own deployments.
# Includes a default NSG (zero-trust) and empty route table for future NVA.
# =============================================================================

resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]

  tags = var.tags
}

# =============================================================================
# Default Network Security Group (Zero Trust)
# =============================================================================
# Workload teams should associate this NSG with their subnets
# and add explicit allow rules as needed.

resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.name}-default"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Zero trust: deny all inbound by default
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

  # Zero trust: deny all outbound by default
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

# =============================================================================
# Default Route Table
# =============================================================================
# Empty route table - add NVA next-hop routes when NVA is deployed.
# Workload teams should associate this route table with their subnets.

resource "azurerm_route_table" "default" {
  name                = "rt-${var.name}-default"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Disable BGP propagation for spoke traffic control
  bgp_route_propagation_enabled = false

  # TODO: Add route to NVA when deployed
  # route {
  #   name                   = "to-nva"
  #   address_prefix         = "0.0.0.0/0"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = "<nva-private-ip>"
  # }

  tags = var.tags
}
