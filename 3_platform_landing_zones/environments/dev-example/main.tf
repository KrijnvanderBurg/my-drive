# -----------------------------------------------------------------------------
# Main Configuration - Example Landing Zone
# Self-service spoke deployment using hub remote state
# -----------------------------------------------------------------------------

module "spoke" {
  source = "../../modules/spoke-vnet"

  workload            = var.workload
  resource_group_name = "rg-${var.workload}-${var.archetype}-${var.environment}-${var.location_short}-01"
  vnet_name           = "vnet-${var.workload}-${var.archetype}-${var.environment}-${var.location_short}-01"
  route_table_name    = "rt-${var.workload}-${var.archetype}-${var.environment}-${var.location_short}-01"
  location            = var.location
  address_space       = var.address_space
  subnets             = var.subnets

  # Hub connectivity from remote state
  hub_vnet_id             = data.terraform_remote_state.hub.outputs.hub_vnet_id
  hub_vnet_name           = data.terraform_remote_state.hub.outputs.hub_vnet_name
  hub_resource_group_name = data.terraform_remote_state.hub.outputs.hub_resource_group_name
  nva_lb_ip               = data.terraform_remote_state.hub.outputs.nva_lb_ip

  # Peering names
  peering_name_spoke_to_hub = "peer-${var.workload}tohub-${var.archetype}-${var.environment}-${var.location_short}-01"
  peering_name_hub_to_spoke = "peer-hubto${var.workload}-${var.archetype}-${var.environment}-${var.location_short}-01"

  # DNS zone links
  dns_zone_ids = {
    blob = {
      zone_name = data.terraform_remote_state.hub.outputs.dns_zone_blob_name
    }
    keyvault = {
      zone_name = data.terraform_remote_state.hub.outputs.dns_zone_keyvault_name
    }
  }

  tags = local.common_tags
}
