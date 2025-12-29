# -----------------------------------------------------------------------------
# Outputs - Germany West Central Hub
# Used by global environment and landing zones via remote state
# -----------------------------------------------------------------------------

# Hub VNet
output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = module.hub_vnet.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = module.hub_vnet.name
}

output "hub_resource_group_name" {
  description = "Name of the hub resource group"
  value       = module.hub_rg.name
}

output "hub_location" {
  description = "Location of the hub"
  value       = var.location
}

# NVA
output "nva_lb_ip" {
  description = "Load balancer IP for NVA (use as next hop)"
  value       = module.nva_ha.lb_private_ip
}

output "nva_primary_ip" {
  description = "Primary NVA private IP (for Ansible)"
  value       = module.nva_ha.nva_primary_private_ip
}

output "nva_secondary_ip" {
  description = "Secondary NVA private IP (for Ansible)"
  value       = module.nva_ha.nva_secondary_private_ip
}

output "nva_primary_vm_name" {
  description = "Primary NVA VM name (for Ansible)"
  value       = module.nva_ha.nva_primary_vm_name
}

output "nva_secondary_vm_name" {
  description = "Secondary NVA VM name (for Ansible)"
  value       = module.nva_ha.nva_secondary_vm_name
}

# DNS Zones
output "dns_zone_blob_id" {
  description = "ID of the blob private DNS zone"
  value       = module.dns_zone_blob.id
}

output "dns_zone_blob_name" {
  description = "Name of the blob private DNS zone"
  value       = module.dns_zone_blob.name
}

output "dns_zone_keyvault_id" {
  description = "ID of the keyvault private DNS zone"
  value       = module.dns_zone_keyvault.id
}

output "dns_zone_keyvault_name" {
  description = "Name of the keyvault private DNS zone"
  value       = module.dns_zone_keyvault.name
}

# Jumpbox
output "jumpbox_private_ip" {
  description = "Private IP of the jumpbox"
  value       = module.jumpbox.private_ip
}

# Platform Spokes
output "identity_vnet_id" {
  description = "ID of the identity spoke VNet"
  value       = module.identity_vnet.id
}

output "management_vnet_id" {
  description = "ID of the management spoke VNet"
  value       = module.management_vnet.id
}
