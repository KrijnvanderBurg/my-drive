# =============================================================================
# Global (glb) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Environment Configuration
  # ---------------------------------------------------------------------------
  environment = "dev"

  # ---------------------------------------------------------------------------
  # Common Tags
  # ---------------------------------------------------------------------------
  common_tags = {
    environment = local.environment
    managed_by  = "opentofu"
    project     = "levendaal"
    layer       = "platform-connectivity"
    region      = "global"
  }

  # ---------------------------------------------------------------------------
  # Regional Hub References (from remote state)
  # ---------------------------------------------------------------------------
  hubs = {
    weu = {
      id                  = data.terraform_remote_state.weu.outputs.hub.id
      name                = data.terraform_remote_state.weu.outputs.hub.name
      resource_group_name = data.terraform_remote_state.weu.outputs.resource_group.name
    }
    gwc = {
      id                  = data.terraform_remote_state.gwc.outputs.hub.id
      name                = data.terraform_remote_state.gwc.outputs.hub.name
      resource_group_name = data.terraform_remote_state.gwc.outputs.resource_group.name
    }
  }

  # ---------------------------------------------------------------------------
  # Private DNS Zones (from regional deployments)
  # ---------------------------------------------------------------------------
  # Used for cross-region DNS linking
  private_dns_zones_weu = data.terraform_remote_state.weu.outputs.private_dns_zones
  private_dns_zones_gwc = data.terraform_remote_state.gwc.outputs.private_dns_zones
}
