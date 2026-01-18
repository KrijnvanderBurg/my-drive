# =============================================================================
# Global (glb) - Main Configuration
# =============================================================================
#
# This deployment manages cross-region resources:
# - Hub-to-Hub VNet peering (global peering between regional hubs)
# - Cross-region Private DNS links
#
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

# =============================================================================
# Cross-Region Private DNS Links
# =============================================================================
# Link each region's DNS zones to the other region's hub VNet.
# This enables DNS resolution for Private Endpoints across regions.
# =============================================================================

# Link WEU DNS zones to GWC hub
resource "azurerm_private_dns_zone_virtual_network_link" "weu_dns_to_gwc_hub" {
  for_each = local.private_dns_zones_weu

  name                  = "link-weu-${replace(each.key, ".", "-")}-to-gwc-hub"
  resource_group_name   = data.terraform_remote_state.weu.outputs.resource_group.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = local.hubs.gwc.id
  registration_enabled  = false

  tags = local.common_tags
}

# Link GWC DNS zones to WEU hub
resource "azurerm_private_dns_zone_virtual_network_link" "gwc_dns_to_weu_hub" {
  for_each = local.private_dns_zones_gwc

  name                  = "link-gwc-${replace(each.key, ".", "-")}-to-weu-hub"
  resource_group_name   = data.terraform_remote_state.gwc.outputs.resource_group.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = local.hubs.weu.id
  registration_enabled  = false

  tags = local.common_tags
}
