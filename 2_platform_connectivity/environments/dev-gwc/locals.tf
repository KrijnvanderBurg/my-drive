# -----------------------------------------------------------------------------
# Locals - Germany West Central Hub
# -----------------------------------------------------------------------------

locals {
  common_tags = merge(var.tags, {
    environment = var.environment
    region      = var.location_short
    managed_by  = "opentofu"
    project     = "levendaal"
  })

  # Naming convention: <type>-<workload>-<archetype>-<env>-<region>-<instance>
  hub_rg_name   = "rg-hub-co-${var.environment}-${var.location_short}-01"
  hub_vnet_name = "vnet-hub-co-${var.environment}-${var.location_short}-01"
}
