# =============================================================================
# Local Values
# =============================================================================

locals {
  # Common tags applied to all resources
  common_tags = merge(
    var.tags,
    {
      environment = var.environment
      managed_by  = "opentofu"
      project     = "levendaal"
    }
  )
}
