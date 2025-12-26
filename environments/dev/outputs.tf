# =============================================================================
# Management Group Outputs
# =============================================================================

output "tenant_root_management_group_id" {
  description = "The fully qualified ID of the tenant root management group"
  value       = data.azurerm_management_group.tenant_root.id
}

output "drive_management_group" {
  description = "drive management group details"
  value = {
    id           = module.drive_management_group.id
    name         = module.drive_management_group.name
    display_name = module.drive_management_group.display_name
  }
}

output "sandbox_management_group" {
  description = "Sandbox management group details"
  value = {
    id           = module.sandbox_management_group.id
    name         = module.sandbox_management_group.name
    display_name = module.sandbox_management_group.display_name
  }
}

# =============================================================================
# Environment Information
# =============================================================================

output "environment_info" {
  description = "Current environment configuration"
  value = {
    tenant_id   = var.tenant_id
    environment = var.environment
  }
}
