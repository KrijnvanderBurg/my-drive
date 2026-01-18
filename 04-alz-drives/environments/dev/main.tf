# =============================================================================
# Dev Environment - Platform Storage
# =============================================================================

module "drive" {
  source = "../../modules/drive"

  environment = local.environment
  region      = local.region
  location    = local.location
  allowed_ips = local.allowed_ips
  tags        = local.common_tags

  containers = [
    "tier1",
  ]
}
