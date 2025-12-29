# -----------------------------------------------------------------------------
# Locals - Global Connectivity
# -----------------------------------------------------------------------------

locals {
  common_tags = merge(var.tags, {
    environment = var.environment
    managed_by  = "opentofu"
    project     = "levendaal"
  })
}
