# =============================================================================
# Drives Landing Zone (dev) - Main Configuration
# =============================================================================

# =============================================================================
# Resource Group - Landing Zone Workloads
# =============================================================================

resource "azurerm_resource_group" "workloads" {
  name     = "rg-${local.landing_zone}-${local.environment}-${local.location_short}-01"
  location = local.location

  tags = local.common_tags
}

# =============================================================================
# Subnets (in spoke VNet managed by connectivity)
# =============================================================================

module "subnet" {
  source   = "../../modules/subnet"
  for_each = local.subnets

  name                   = each.key
  resource_group_name    = local.spoke_resource_group_name
  virtual_network_name   = local.spoke_vnet_name
  address_prefixes       = [each.value.address_prefix]
  location               = local.location
  service_endpoints      = each.value.service_endpoints
  default_nsg_id         = local.spoke_default_nsg_id
  default_route_table_id = local.spoke_default_route_table_id

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
