# =============================================================================
# Dev Environment - Platform Storage
# =============================================================================

module "drive" {
  source = "../../modules/drive"

  environment = var.environment
  region      = local.region
  location    = local.location
  allowed_ips = var.allowed_ips
  tags        = local.common_tags
}
