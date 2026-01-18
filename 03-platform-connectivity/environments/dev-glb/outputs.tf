# =============================================================================
# Global (glb) - Outputs
# =============================================================================

# =============================================================================
# Hub-to-Hub Peerings
# =============================================================================

output "hub_peerings" {
  description = "Hub-to-hub VNet peering details"
  value = {
    weu_to_gwc = {
      id   = module.hub_weu_to_hub_gwc.id
      name = module.hub_weu_to_hub_gwc.name
    }
    gwc_to_weu = {
      id   = module.hub_gwc_to_hub_weu.id
      name = module.hub_gwc_to_hub_weu.name
    }
  }
}

# =============================================================================
# Cross-Region DNS Links
# =============================================================================

output "cross_region_dns_links" {
  description = "Cross-region Private DNS VNet links"
  value = {
    weu_dns_to_gwc_hub = { for k, v in azurerm_private_dns_zone_virtual_network_link.weu_dns_to_gwc_hub : k => v.id }
    gwc_dns_to_weu_hub = { for k, v in azurerm_private_dns_zone_virtual_network_link.gwc_dns_to_weu_hub : k => v.id }
  }
}

# =============================================================================
# Regional References (passthrough for convenience)
# =============================================================================

output "regional_hubs" {
  description = "Regional hub details (from remote state)"
  value       = local.hubs
}
