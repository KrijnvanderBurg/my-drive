# -----------------------------------------------------------------------------
# Local Values
# -----------------------------------------------------------------------------

locals {
  environment    = "dev"
  location       = "germanywestcentral"
  location_short = "gwc"

  # Hub VNet configuration
  hub_address_space = ["10.100.0.0/22"] # 10.100.0.0 - 10.100.3.255 (1024 IPs)

  tags = {
    environment = local.environment
    managed_by  = "opentofu"
    layer       = "connectivity-hub"
    region      = local.location_short
  }
}
