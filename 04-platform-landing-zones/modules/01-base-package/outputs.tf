# =============================================================================
# Log Analytics Outputs
# =============================================================================

output "log_analytics_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.this.name
}

output "log_analytics_workspace_id" {
  description = "Workspace ID (GUID) of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "log_analytics_primary_shared_key" {
  description = "Primary shared key of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

# =============================================================================
# Storage Account Outputs (Log Export)
# =============================================================================

output "storage_account_logs_id" {
  description = "ID of the storage account for log exports"
  value       = azurerm_storage_account.logs.id
}

output "storage_account_logs_name" {
  description = "Name of the storage account for log exports"
  value       = azurerm_storage_account.logs.name
}

output "storage_container_logs_name" {
  description = "Name of the storage container for log exports"
  value       = azurerm_storage_container.logs.name
}

# =============================================================================
# Key Vault Outputs
# =============================================================================

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

# =============================================================================
# Spoke VNet Output (Nested Structure)
# =============================================================================

output "spoke" {
  description = "Spoke virtual network with all subnets and associated resources"
  value = {
    id            = azurerm_virtual_network.this.id
    name          = azurerm_virtual_network.this.name
    address_space = azurerm_virtual_network.this.address_space

    # Landing zone managed subnets (with NSG and route table)
    lz_managed_subnets = {
      for key, subnet in azurerm_subnet.lz_managed : key => {
        id             = subnet.id
        name           = subnet.name
        address_prefix = subnet.address_prefixes[0]
        nsg = {
          id   = azurerm_network_security_group.lz_managed[key].id
          name = azurerm_network_security_group.lz_managed[key].name
        }
        route_table = {
          id   = azurerm_route_table.lz_managed[key].id
          name = azurerm_route_table.lz_managed[key].name
        }
      }
    }

    # Azure reserved subnets (no NSG/route table)
    azure_reserved_subnets = {
      for key, subnet in azurerm_subnet.azure_reserved : key => {
        id             = subnet.id
        name           = subnet.name
        address_prefix = subnet.address_prefixes[0]
      }
    }

    # Azure delegated subnets (no NSG/route table)
    azure_delegated_subnets = {
      for key, subnet in azurerm_subnet.azure_delegated : key => {
        id             = subnet.id
        name           = subnet.name
        address_prefix = subnet.address_prefixes[0]
      }
    }
  }
}
