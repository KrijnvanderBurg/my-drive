# =============================================================================
# West Europe (weu) - Main Configuration
# =============================================================================

# =============================================================================
# Hub Network
# =============================================================================

module "hub" {
  source = "../../modules/hub-network"

  name                  = "vnet-hub-co-${local.environment}-${local.region}-01"
  resource_group_name   = "rg-connectivity-on-${local.environment}-${local.region}-01"
  location              = local.location
  address_space         = local.hub_cidr
  azure_subnets         = local.hub_azure_subnets
  managed_subnets       = local.hub_managed_subnets
  create_resource_group = true

  tags = local.common_tags
}

# =============================================================================
# Spoke Networks
# =============================================================================

module "spoke" {
  source   = "../../modules/spoke-network"
  for_each = local.spoke_cidrs

  providers = {
    azurerm.hub = azurerm
  }

  name                = "vnet-${each.key}-co-${local.environment}-${local.region}-01"
  resource_group_name = module.hub.resource_group_name
  location            = local.location
  address_space       = [each.value]

  hub_vnet_name           = module.hub.name
  hub_vnet_id             = module.hub.id
  hub_resource_group_name = module.hub.resource_group_name
  peering_name_suffix     = each.key

  tags = local.common_tags
}

# =============================================================================
# Private DNS Zones (CENTRALIZED - Global DNS Management)
# =============================================================================

module "private_dns" {
  source   = "../../modules/private-dns-zone"
  for_each = toset(local.private_dns_zones)

  name                = each.value
  resource_group_name = module.hub.resource_group_name

  virtual_network_links = {
    hub-weu = local.hub_weu_id
    hub-gwc = local.hub_gwc_id
  }

  tags = merge(
    local.common_tags,
    {
      "dns-scope"  = "global"
      "managed-in" = "weu"
    }
  )
}

# =============================================================================
# Landing Zone: Drives - Spoke Network (deployed in LZ subscription)
# =============================================================================

module "lz_spoke_drives" {
  source = "../../modules/spoke-network"

  providers = {
    azurerm     = azurerm.plz_drives
    azurerm.hub = azurerm
  }

  name                            = "vnet-drives-on-${local.environment}-${local.region}-01"
  resource_group_name             = "rg-connectivity-drives-${local.environment}-${local.region}-01"
  location                        = local.location
  address_space                   = local.lz_spoke_cidrs["drives"]
  create_resource_group           = true

  hub_vnet_name                   = module.hub.name
  hub_vnet_id                     = module.hub.id
  hub_resource_group_name         = module.hub.resource_group_name
  peering_name_suffix             = "drives-${local.environment}-${local.region}"

  private_dns_zones               = toset(local.private_dns_zones)
  private_dns_resource_group_name = module.hub.resource_group_name

  tags = merge(local.common_tags, {
    landing_zone = "drives"
  })
}
