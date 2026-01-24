# =============================================================================
# Drives Landing Zone (dev) - Main Configuration
# =============================================================================

# =============================================================================
# Spoke Network (owned by this landing zone)
# =============================================================================

module "spoke" {
  source = "../../../03-platform-connectivity/modules/spoke-network"

  name                = "vnet-${local.landing_zone}-on-${local.environment}-${local.location_short}-01"
  resource_group_name = "rg-connectivity-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location            = local.location
  address_space       = [local.spoke_cidr]

  hub_vnet_id   = local.hub_vnet_id
  hub_vnet_name = local.hub_vnet_name

  tags = local.common_tags
}

# spoke_cidrs = {
#   identity = cidrsubnet(local.location_cidr, 4, 1) # 10.1.16.0/20  (4,096 IPs)
#   data     = cidrsubnet(local.location_cidr, 4, 2) # 10.1.32.0/20  (4,096 IPs)
#   app      = cidrsubnet(local.location_cidr, 4, 3) # 10.1.48.0/20  (4,096 IPs)
#   web      = cidrsubnet(local.location_cidr, 4, 4) # 10.1.64.0/20  (4,096 IPs)
#   shared   = cidrsubnet(local.location_cidr, 4, 5) # 10.1.80.0/20  (4,096 IPs)
# }


# module "spokes" {
#   source     = "../../modules/spoke-network"
#   for_each   = local.spoke_cidrs
#   depends_on = [module.hub]

#   name                = "vnet-${each.key}-co-${local.environment}-${local.location_short}-01"
#   resource_group_name = module.hub.resource_group_name
#   location            = local.location
#   address_space       = [each.value]

#   hub_vnet_id   = module.hub.id
#   hub_vnet_name = module.hub.name

#   tags = local.common_tags
# }


# =============================================================================
# Hub-to-Spoke Peering (created in connectivity subscription)
# =============================================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider   = azurerm.connectivity
  depends_on = [module.spoke]

  name                      = "peer-${local.hub_vnet_name}-to-${module.spoke.name}"
  resource_group_name       = local.hub_resource_group_name
  virtual_network_name      = local.hub_vnet_name
  remote_virtual_network_id = module.spoke.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# =============================================================================
# Private DNS Zone Links (created in connectivity subscription)
# =============================================================================

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  provider   = azurerm.connectivity
  for_each   = toset(local.private_dns_zones)
  depends_on = [module.spoke]

  name                  = "link-${module.spoke.name}"
  resource_group_name   = local.hub_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = module.spoke.id
  registration_enabled  = false

  tags = local.common_tags
}

# =============================================================================
# Resource Group - Landing Zone Workloads
# =============================================================================

resource "azurerm_resource_group" "workloads" {
  name     = "rg-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location = local.location

  tags = local.common_tags
}

# =============================================================================
# Subnets (in spoke VNet owned by this landing zone)
# =============================================================================

module "subnet" {
  source     = "../../modules/subnet"
  for_each   = local.subnets
  depends_on = [module.spoke]

  name                   = each.key
  resource_group_name    = module.spoke.resource_group_name
  virtual_network_name   = module.spoke.name
  address_prefixes       = [each.value.address_prefix]
  location               = local.location
  service_endpoints      = each.value.service_endpoints
  default_nsg_id         = module.spoke.default_nsg_id
  default_route_table_id = module.spoke.default_route_table_id

  tags = local.common_tags
}

# =============================================================================
# Log Analytics Workspace (created first - used by all other resources)
# =============================================================================

module "log_analytics" {
  source = "../../modules/log-analytics"

  name                = "log-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  resource_group_name = azurerm_resource_group.workloads.name
  location            = local.location
  retention_in_days   = 30

  tags = local.common_tags
}

# =============================================================================
# Key Vault
# =============================================================================

module "key_vault" {
  source = "../../modules/key-vault"

  name                       = "kv-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  resource_group_name        = azurerm_resource_group.workloads.name
  location                   = local.location
  tenant_id                  = local.tenant_id
  log_analytics_workspace_id = module.log_analytics.id

  tags = local.common_tags
}

# =============================================================================
# Storage Account
# =============================================================================

module "storage_account" {
  source = "../../modules/storage-account"

  name                       = "st${local.landing_zone}${local.environment}${local.location_short}01"
  resource_group_name        = azurerm_resource_group.workloads.name
  location                   = local.location
  log_analytics_workspace_id = module.log_analytics.id

  tags = local.common_tags
}

# =============================================================================
# Container Registry
# =============================================================================

module "container_registry" {
  source = "../../modules/container-registry"

  name                       = "cr${local.landing_zone}${local.environment}${local.location_short}01"
  resource_group_name        = azurerm_resource_group.workloads.name
  location                   = local.location
  sku                        = "Basic"
  log_analytics_workspace_id = module.log_analytics.id

  tags = local.common_tags
}

# =============================================================================
# App Service Plan
# =============================================================================

module "app_service_plan" {
  source = "../../modules/app-service-plan"

  name                       = "asp-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  resource_group_name        = azurerm_resource_group.workloads.name
  location                   = local.location
  os_type                    = "Linux"
  sku_name                   = "B1"
  log_analytics_workspace_id = module.log_analytics.id

  tags = local.common_tags
}
