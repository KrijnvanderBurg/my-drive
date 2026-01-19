# =============================================================================
# Global (glb) - Main Configuration
# =============================================================================
#
# This deployment manages cross-region resources:
# - Hub-to-Hub VNet peering (global peering between regional hubs)
#
# NOTE: Cross-region Private DNS links are now managed in the WEU deployment
# The centralized DNS architecture links zones to all hubs directly
# =============================================================================

# =============================================================================
# Hub-to-Hub Global VNet Peering
# =============================================================================
# Global VNet peering allows the regional hubs to communicate directly.
# Traffic flows hub <-> hub for cross-region connectivity.
# This enables spokes in different regions to reach each other via their hubs.
# =============================================================================

# West Europe Hub -> Germany West Central Hub
module "hub_weu_to_hub_gwc" {
  source = "../../modules/vnet-peering"

  name                      = "peer-hub-weu-to-hub-gwc"
  resource_group_name       = local.hubs.weu.resource_group_name
  virtual_network_name      = local.hubs.weu.name
  remote_virtual_network_id = local.hubs.gwc.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true # Allow WEU hub to act as transit
}

# Germany West Central Hub -> West Europe Hub
module "hub_gwc_to_hub_weu" {
  source = "../../modules/vnet-peering"

  name                      = "peer-hub-gwc-to-hub-weu"
  resource_group_name       = local.hubs.gwc.resource_group_name
  virtual_network_name      = local.hubs.gwc.name
  remote_virtual_network_id = local.hubs.weu.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true # Allow GWC hub to act as transit
}
