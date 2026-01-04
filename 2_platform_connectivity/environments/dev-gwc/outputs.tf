# -----------------------------------------------------------------------------
# Hub Outputs
# -----------------------------------------------------------------------------
# These outputs are consumed by spoke deployments via remote state.
# -----------------------------------------------------------------------------

output "hub_vnet_id" {
  description = "ID of the hub VNet"
  value       = module.hub_vnet.hub_vnet_id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet"
  value       = module.hub_vnet.hub_vnet_name
}

output "hub_resource_group_name" {
  description = "Name of the hub resource group"
  value       = module.hub_vnet.hub_resource_group_name
}

output "hub_route_table_id" {
  description = "ID of the hub route table (for spoke association)"
  value       = azurerm_route_table.hub.id
}

output "hub_route_table_name" {
  description = "Name of the hub route table"
  value       = azurerm_route_table.hub.name
}

output "dns_resource_group_name" {
  description = "Name of the resource group containing Private DNS zones"
  value       = split("/", data.terraform_remote_state.connectivity-global.outputs.dns_zone_blob_id)[4]
}

output "dns_zone_blob_name" {
  description = "Name of the blob private DNS zone"
  value       = data.terraform_remote_state.connectivity-global.outputs.dns_zone_blob_name
}

output "dns_zone_keyvault_name" {
  description = "Name of the KeyVault private DNS zone"
  value       = data.terraform_remote_state.connectivity-global.outputs.dns_zone_keyvault_name
}
