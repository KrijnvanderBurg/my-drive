# -----------------------------------------------------------------------------
# Outputs - Example Landing Zone
# -----------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the spoke resource group"
  value       = module.spoke.resource_group_name
}

output "vnet_id" {
  description = "ID of the spoke VNet"
  value       = module.spoke.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = module.spoke.subnet_ids
}
