# =============================================================================
# Drives Landing Zone (dev) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  tenant_id                    = data.terraform_remote_state.management.outputs.tenant_id
  subscription_id              = data.terraform_remote_state.management.outputs.plz_drives_subscription.subscription_id
  connectivity_subscription_id = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id

  # Hub VNet from connectivity layer (for peering)
  hub_vnet_id             = data.terraform_remote_state.connectivity_weu.outputs.hub.id
  hub_vnet_name           = data.terraform_remote_state.connectivity_weu.outputs.hub.name
  hub_resource_group_name = data.terraform_remote_state.connectivity_weu.outputs.hub.resource_group_name

  # Private DNS zones from connectivity layer
  private_dns_zones = keys(data.terraform_remote_state.connectivity_weu.outputs.private_dns_zones)

  # ---------------------------------------------------------------------------
  # location_short Configuration (easily changeable)
  # ---------------------------------------------------------------------------
  location       = "westeurope"
  location_short = "weu"
  environment    = "dev"
  landing_zone   = "drives"

  # ---------------------------------------------------------------------------
  # Common Tags
  # ---------------------------------------------------------------------------
  common_tags = {
    environment    = local.environment
    managed_by     = "opentofu"
    project        = "levendaal"
    layer          = "platform-landing-zone"
    landing_zone   = local.landing_zone
    location_short = local.location_short
  }

  # ---------------------------------------------------------------------------
  # Spoke Network Configuration
  # ---------------------------------------------------------------------------
  # IP allocation follows connectivity layer convention:
  # location_short WEU = 10.1.0.0/16, slot 6 = LZ drives
  # ---------------------------------------------------------------------------

  spoke_cidr = "10.1.96.0/20" # 4,096 IPs for drives landing zone

  # ---------------------------------------------------------------------------
  # Subnet Configuration
  # ---------------------------------------------------------------------------
  # Subnets within the spoke VNet CIDR (10.1.96.0/20 = 4,096 IPs)
  # Using /24 subnets = 256 IPs each, leaving room for growth
  # ---------------------------------------------------------------------------

  subnets = {
    "snet-app-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = "10.1.96.0/24" # 256 IPs for app services
      service_endpoints = []
    }
    "snet-data-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = "10.1.97.0/24" # 256 IPs for data services
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
    "snet-privateendpoints-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = "10.1.98.0/24" # 256 IPs for future private endpoints
      service_endpoints = []
    }
  }
}
