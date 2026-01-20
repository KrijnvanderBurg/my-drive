# =============================================================================
# Resource Group Outputs
# =============================================================================

output "resource_group" {
  description = "Landing zone workloads resource group"
  value = {
    id       = azurerm_resource_group.workloads.id
    name     = azurerm_resource_group.workloads.name
    location = azurerm_resource_group.workloads.location
  }
}

# =============================================================================
# Subnet Outputs
# =============================================================================

output "subnets" {
  description = "Landing zone subnets"
  value = {
    for name, subnet in module.subnet : name => {
      id               = subnet.id
      name             = subnet.name
      address_prefixes = subnet.address_prefixes
    }
  }
}

# =============================================================================
# Log Analytics Outputs
# =============================================================================

output "log_analytics" {
  description = "Log Analytics workspace"
  value = {
    id           = module.log_analytics.id
    name         = module.log_analytics.name
    workspace_id = module.log_analytics.workspace_id
  }
}

# =============================================================================
# Key Vault Outputs
# =============================================================================

output "key_vault" {
  description = "Key Vault"
  value = {
    id        = module.key_vault.id
    name      = module.key_vault.name
    vault_uri = module.key_vault.vault_uri
  }
}

# =============================================================================
# Storage Account Outputs
# =============================================================================

output "storage_account" {
  description = "Storage Account"
  value = {
    id                    = module.storage_account.id
    name                  = module.storage_account.name
    primary_blob_endpoint = module.storage_account.primary_blob_endpoint
    primary_file_endpoint = module.storage_account.primary_file_endpoint
  }
}

# =============================================================================
# Container Registry Outputs
# =============================================================================

output "container_registry" {
  description = "Container Registry"
  value = {
    id           = module.container_registry.id
    name         = module.container_registry.name
    login_server = module.container_registry.login_server
  }
}

# =============================================================================
# App Service Plan Outputs
# =============================================================================

output "app_service_plan" {
  description = "App Service Plan"
  value = {
    id   = module.app_service_plan.id
    name = module.app_service_plan.name
    kind = module.app_service_plan.kind
  }
}
