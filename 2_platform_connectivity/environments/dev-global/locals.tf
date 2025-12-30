# -----------------------------------------------------------------------------
# Locals - Global Connectivity
# -----------------------------------------------------------------------------

locals {
  pr_suffix = "-pr${var.pr_number}"

  common_tags = merge(var.tags, {
    environment = var.environment
    managed_by  = "opentofu"
    project     = "levendaal"
    pr_number   = var.pr_number
  })
}
