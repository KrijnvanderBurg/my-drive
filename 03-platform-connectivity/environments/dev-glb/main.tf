# =============================================================================
# Global (glb) - Main Configuration
# =============================================================================
#
# This deployment manages cross-location_short resources:
# - Hub-to-Hub VNet peering (global peering between location_shortal hubs)
# - Hub-to-Hub Network Verifier intents
#
# NOTE: Cross-location_short Private DNS links are managed in the WEU deployment
# =============================================================================

# West Europe Hub -> Germany West Central Hub
module "hub_weu_to_hub_gwc" {
  source = "../../modules/02-hub-peering"

  name                      = "peer-hub-weu-to-hub-gwc"
  resource_group_name       = local.hubs.weu.resource_group_name
  virtual_network_name      = local.hubs.weu.name
  remote_virtual_network_id = local.hubs.gwc.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true # Allow WEU hub to act as transit
}

# Germany West Central Hub -> West Europe Hub
module "hub_gwc_to_hub_weu" {
  source = "../../modules/02-hub-peering"

  name                      = "peer-hub-gwc-to-hub-weu"
  resource_group_name       = local.hubs.gwc.resource_group_name
  virtual_network_name      = local.hubs.gwc.name
  remote_virtual_network_id = local.hubs.weu.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true # Allow GWC hub to act as transit
}
