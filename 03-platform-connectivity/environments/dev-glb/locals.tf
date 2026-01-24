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
    environment    = local.environment
    managed_by     = "opentofu"
    project        = "levendaal"
    layer          = "platform-connectivity"
    location_short = "global"
  }

  # ---------------------------------------------------------------------------
  # location_shortal Hub References (from remote state)
  # ---------------------------------------------------------------------------
  hubs = {
    weu = {
      id                  = data.terraform_remote_state.weu.outputs.hub.id
      name                = data.terraform_remote_state.weu.outputs.hub.name
      resource_group_name = data.terraform_remote_state.weu.outputs.hub.resource_group_name
    }
    gwc = {
      id                  = data.terraform_remote_state.gwc.outputs.hub.id
      name                = data.terraform_remote_state.gwc.outputs.hub.name
      resource_group_name = data.terraform_remote_state.gwc.outputs.hub.resource_group_name
    }
  }


  # # ---------------------------------------------------------------------------
  # # Private DNS Zones
  # # ---------------------------------------------------------------------------
  # # Common Private Link DNS zones for Azure services
  # # ---------------------------------------------------------------------------

  # private_dns_zones = [
  #   "privatelink.blob.core.windows.net",
  #   "privatelink.file.core.windows.net",
  #   "privatelink.queue.core.windows.net",
  #   "privatelink.table.core.windows.net",
  #   "privatelink.vaultcore.azure.net",
  #   "privatelink.database.windows.net",
  #   "privatelink.documents.azure.com",
  #   "privatelink.azurecr.io",
  #   "privatelink.azurewebsites.net",
  # ]
}
