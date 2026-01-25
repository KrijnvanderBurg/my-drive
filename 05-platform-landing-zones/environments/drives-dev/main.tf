module "vnet-spoke" {
  source = "../../modules/01-vnet-spoke"

  name                = "vnet-${local.landing_zone}-on-${local.environment}-${local.location_short}-01"
  resource_group_name = "rg-connectivity-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location            = local.location
  address_space       = [local.spoke_cidr]

  hub_vnet_id             = local.hub_vnet_id
  hub_vnet_name           = local.hub_vnet_name
  use_remote_gateways     = true
  hub_resource_group_name = local.hub_resource_group_name

  lz_managed_subnets      = local.lz_managed_subnets
  azure_reserved_subnets  = local.azure_reserved_subnets
  azure_delegated_subnets = local.azure_delegated_subnets

  tags = local.common_tags
}
