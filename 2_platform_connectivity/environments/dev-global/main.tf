# -----------------------------------------------------------------------------
# Global Connectivity Resources
# -----------------------------------------------------------------------------
# This deployment creates global/shared resources for the connectivity layer:
# - Private DNS Zones for Azure Private Endpoints (blob, KeyVault, etc.)
#
# Regional hub deployments will link these DNS zones to their hub VNets.
# -----------------------------------------------------------------------------

module "private_dns_zones" {
  source = "../../modules/private-dns-zones"

  resource_group_name = "rg-dns-co-${local.environment}-${local.location_short}-01"
  location            = local.location
  tags                = local.tags
}
