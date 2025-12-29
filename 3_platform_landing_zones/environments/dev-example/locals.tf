# -----------------------------------------------------------------------------
# Locals - Example Landing Zone
# -----------------------------------------------------------------------------

locals {
  common_tags = merge(var.tags, {
    environment = var.environment
    region      = var.location_short
    managed_by  = "opentofu"
    workload    = var.workload
  })
}
