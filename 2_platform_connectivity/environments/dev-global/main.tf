# -----------------------------------------------------------------------------
# Main Configuration - Global Connectivity
# Hub-to-Hub Global VNet Peering, Cross-region Load Balancer, DNS
# -----------------------------------------------------------------------------

# =============================================================================
# HUB-TO-HUB GLOBAL VNET PEERING
# Uncomment when second region (e.g., WEU) is deployed
# =============================================================================

# module "hub_to_hub_peering" {
#   source = "../../modules/vnet-peering"
#
#   peering_name_source_to_destination = "peer-hubgwctohubweu-co-${var.environment}-glb-01"
#   peering_name_destination_to_source = "peer-hubweutohubgwc-co-${var.environment}-glb-01"
#
#   # GWC Hub (source)
#   source_resource_group_name  = data.terraform_remote_state.hub_gwc.outputs.hub_resource_group_name
#   source_virtual_network_name = data.terraform_remote_state.hub_gwc.outputs.hub_vnet_name
#   source_virtual_network_id   = data.terraform_remote_state.hub_gwc.outputs.hub_vnet_id
#
#   # WEU Hub (destination)
#   destination_resource_group_name  = data.terraform_remote_state.hub_weu.outputs.hub_resource_group_name
#   destination_virtual_network_name = data.terraform_remote_state.hub_weu.outputs.hub_vnet_name
#   destination_virtual_network_id   = data.terraform_remote_state.hub_weu.outputs.hub_vnet_id
#
#   allow_forwarded_traffic           = true
#   source_allow_gateway_transit      = false
#   destination_allow_gateway_transit = false
# }
