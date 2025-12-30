# -----------------------------------------------------------------------------
# Locals - Example Landing Zone
# -----------------------------------------------------------------------------

locals {
  pr_suffix = "-pr${var.pr_number}"

  common_tags = merge(var.tags, {
    environment = var.environment
    region      = var.location_short
    managed_by  = "opentofu"
    workload    = var.workload
    pr_number   = var.pr_number
  })
}
