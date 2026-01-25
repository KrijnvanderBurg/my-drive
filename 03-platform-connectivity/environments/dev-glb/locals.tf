# =============================================================================
# Enterprise IP Address Allocation
# =============================================================================
# Enterprise-wide CIDR allocation using cidrsubnet() for calculation.
#
# Supernet: 10.0.0.0/8 (16,777,216 IPs total)
#
# ├── 10.1.0.0/16     West Europe (weu)              [65,536 IPs - ACTIVE]
# │   ├── 10.1.0.0/20      Hub Network                (4,096 IPs - slot 0)
# │   ├── 10.1.16.0/20     Spoke: plz-drives          (4,096 IPs - slot 1)
# │   └── 10.1.64.0/18     Reserved (slots 4-15)     (57,344 IPs - future)
# │
# ├── 10.2.0.0/16     Germany West Central (gwc)     [65,536 IPs - ACTIVE]
# │   ├── 10.2.0.0/20      Hub Network                (4,096 IPs - slot 0)
# │   └── 10.2.16.0/20     Reserved (slots 1-15)     (61,440 IPs - future)
# │
# └── 10.3.0.0/16+    Reserved (regions 3+)          [Future expansion]
#
# Notes:
#   - Each region gets a /16 block (65,536 IPs)
#   - Each region divided into /20 slots (4,096 IPs each, 16 slots total)
#   - Slot 0 always reserved for hub network
#   - Slots 1+ allocated for spoke networks as needed
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
      address_space       = data.terraform_remote_state.weu.outputs.hub.address_space
    }
    gwc = {
      id                  = data.terraform_remote_state.gwc.outputs.hub.id
      name                = data.terraform_remote_state.gwc.outputs.hub.name
      resource_group_name = data.terraform_remote_state.gwc.outputs.hub.resource_group_name
      address_space       = data.terraform_remote_state.gwc.outputs.hub.address_space
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
