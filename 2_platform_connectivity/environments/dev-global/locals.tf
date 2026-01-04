# -----------------------------------------------------------------------------
# Local Values
# -----------------------------------------------------------------------------

locals {
  environment    = "dev"
  location       = "westeurope"
  location_short = "weu"

  tags = {
    environment = local.environment
    managed_by  = "opentofu"
    layer       = "connectivity-global"
  }
}
