# -----------------------------------------------------------------------------
# Private DNS Zone Outputs
# -----------------------------------------------------------------------------
# These outputs are consumed by regional hub deployments via remote state.
# -----------------------------------------------------------------------------

output "dns_zone_blob_id" {
  description = "ID of the blob private DNS zone"
  value       = module.private_dns_zones.dns_zone_blob_id
}

output "dns_zone_blob_name" {
  description = "Name of the blob private DNS zone"
  value       = module.private_dns_zones.dns_zone_blob_name
}

output "dns_zone_keyvault_id" {
  description = "ID of the KeyVault private DNS zone"
  value       = module.private_dns_zones.dns_zone_keyvault_id
}

output "dns_zone_keyvault_name" {
  description = "Name of the KeyVault private DNS zone"
  value       = module.private_dns_zones.dns_zone_keyvault_name
}

output "dns_zone_file_id" {
  description = "ID of the file private DNS zone"
  value       = module.private_dns_zones.dns_zone_file_id
}

output "dns_zone_file_name" {
  description = "Name of the file private DNS zone"
  value       = module.private_dns_zones.dns_zone_file_name
}

output "dns_zone_queue_id" {
  description = "ID of the queue private DNS zone"
  value       = module.private_dns_zones.dns_zone_queue_id
}

output "dns_zone_queue_name" {
  description = "Name of the queue private DNS zone"
  value       = module.private_dns_zones.dns_zone_queue_name
}

output "dns_zone_table_id" {
  description = "ID of the table private DNS zone"
  value       = module.private_dns_zones.dns_zone_table_id
}

output "dns_zone_table_name" {
  description = "Name of the table private DNS zone"
  value       = module.private_dns_zones.dns_zone_table_name
}
