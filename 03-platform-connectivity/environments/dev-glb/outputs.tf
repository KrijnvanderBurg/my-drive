# =============================================================================
# Hub Peering Outputs
# =============================================================================

output "hub_peerings" {
  description = "Hub-to-hub peering details"
  value = {
    weu_to_gwc = {
      id            = module.hub_weu_to_hub_gwc.id
      name          = module.hub_weu_to_hub_gwc.name
      peering_state = module.hub_weu_to_hub_gwc.peering_state
    }
    gwc_to_weu = {
      id            = module.hub_gwc_to_hub_weu.id
      name          = module.hub_gwc_to_hub_weu.name
      peering_state = module.hub_gwc_to_hub_weu.peering_state
    }
  }
}

output "hub_summary" {
  description = "Summary of all regional hubs"
  value = {
    weu = {
      id   = local.hubs.weu.id
      name = local.hubs.weu.name
    }
    gwc = {
      id   = local.hubs.gwc.id
      name = local.hubs.gwc.name
    }
  }
}