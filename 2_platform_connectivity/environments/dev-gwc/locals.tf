# -----------------------------------------------------------------------------
# Locals - Germany West Central Hub
# -----------------------------------------------------------------------------

locals {
  pr_suffix   = "-pr${var.pr_number}"
  environment = var.environment

  common_tags = merge(var.tags, {
    environment = var.environment
    region      = var.location_short
    managed_by  = "opentofu"
    project     = "levendaal"
    pr_number   = var.pr_number
  })

  # Naming convention: <type>-<workload>-<archetype>-<env>-<region>-<instance><pr_suffix>
  hub_rg_name   = "rg-hub-co-${var.environment}-${var.location_short}-01${local.pr_suffix}"
  hub_vnet_name = "vnet-hub-co-${var.environment}-${var.location_short}-01${local.pr_suffix}"
}
