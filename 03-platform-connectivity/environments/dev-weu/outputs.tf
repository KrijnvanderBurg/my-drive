# =============================================================================
# Hub Network Outputs
# =============================================================================

output "hub" {
  description = "Hub VNet details"
  value = {
    id                  = module.hub.id
    name                = module.hub.name
    resource_group_name = module.hub.resource_group_name
    address_space       = module.hub.address_space
  }
}

output "spokes" {
  description = "Spoke VNet details"
  value = {
    plz_drives = {
      cidr = local.plz_drives_cidr
    }
    # ... additional spokes can be added similarly
  }
}
