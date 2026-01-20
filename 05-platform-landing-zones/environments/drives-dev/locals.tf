# =============================================================================
# Drives Landing Zone (dev) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  tenant_id       = data.terraform_remote_state.management.outputs.tenant_id
  subscription_id = data.terraform_remote_state.management.outputs.plz_drives_subscription.subscription_id

  # Spoke VNet from connectivity layer
  spoke_vnet_id                = data.terraform_remote_state.connectivity_weu.outputs.lz_drives_spoke.id
  spoke_vnet_name              = data.terraform_remote_state.connectivity_weu.outputs.lz_drives_spoke.name
  spoke_resource_group_name    = data.terraform_remote_state.connectivity_weu.outputs.lz_drives_spoke.resource_group_name
  spoke_default_nsg_id         = data.terraform_remote_state.connectivity_weu.outputs.lz_drives_spoke.default_nsg_id
  spoke_default_route_table_id = data.terraform_remote_state.connectivity_weu.outputs.lz_drives_spoke.default_route_table_id

  # ---------------------------------------------------------------------------
  # Region Configuration (easily changeable)
  # ---------------------------------------------------------------------------
  location       = "westeurope"
  location_short = "weu"
  environment    = "dev"
  landing_zone   = "drives"

  # ---------------------------------------------------------------------------
  # Common Tags
  # ---------------------------------------------------------------------------
  common_tags = {
    environment  = local.environment
    managed_by   = "opentofu"
    project      = "levendaal"
    layer        = "platform-landing-zone"
    landing_zone = local.landing_zone
    region       = local.location_short
  }

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
