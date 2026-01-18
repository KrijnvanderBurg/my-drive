# =============================================================================
# West Europe (weu) - Outputs
# =============================================================================

# =============================================================================
# Resource Group
# =============================================================================

output "resource_group" {
  description = "Connectivity resource group details"
  value = {
    id       = azurerm_resource_group.connectivity.id
    name     = azurerm_resource_group.connectivity.name
    location = azurerm_resource_group.connectivity.location
  }
}

# =============================================================================
# Hub Network
# =============================================================================

output "hub" {
  description = "Hub virtual network details"
  value = {
    id            = module.hub.id
    name          = module.hub.name
    address_space = module.hub.address_space
    subnets       = module.hub.subnets
  }
}

# =============================================================================
# Spoke Networks
# =============================================================================

output "spokes" {
  description = "Spoke virtual networks details"
  value = {
    for name, spoke in module.spoke : name => {
      id                     = spoke.id
      name                   = spoke.name
      address_space          = spoke.address_space
      default_nsg_id         = spoke.default_nsg_id
      default_route_table_id = spoke.default_route_table_id
    }
  }
}

# =============================================================================
# Private DNS Zones
# =============================================================================

output "private_dns_zones" {
  description = "Private DNS zone details"
  value = {
    for name, zone in module.private_dns : name => {
      id   = zone.id
      name = zone.name
    }
  }
}

# =============================================================================
# IP Address Space (for reference by other deployments)
# =============================================================================

output "ip_space" {
  description = "IP address space allocation for this region"
  value = {
    region_cidr = local.region_cidr
    hub_cidr    = local.hub_cidr
    spoke_cidrs = local.spoke_cidrs
    reserved    = local.reserved_cidrs
  }
}
