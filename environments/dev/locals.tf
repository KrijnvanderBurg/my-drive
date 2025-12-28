# =============================================================================
# Local Values
# =============================================================================

locals {
  # Common tags applied to all resources
  common_tags = merge(
    {
      environment  = var.environment
      managed_by   = "opentofu"
      project      = "levendaal"
      last_updated = timestamp()
    },
    var.tags
  )
}
