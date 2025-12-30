# =============================================================================
# Management Group Outputs
# =============================================================================

output "tenant_root_management_group_id" {
  description = "The fully qualified ID of the tenant root management group"
  value       = data.azurerm_management_group.tenant_root.id
}

output "sandbox_management_group" {
  description = "Sandbox management group details"
  value = {
    id           = module.sandbox_management_group.id
    name         = module.sandbox_management_group.name
    display_name = module.sandbox_management_group.display_name
  }
}

output "management_management_group" {
  description = "Management management group details"
  value = {
    id           = module.management_management_group.id
    name         = module.management_management_group.name
    display_name = module.management_management_group.display_name
  }
}

# =============================================================================
# Subscription Association Outputs
# =============================================================================

output "platform_management_subscription_association" {
  description = "Platform Management subscription association details"
  value = {
    id                  = module.management_subscription_association.id
    management_group_id = module.management_subscription_association.management_group_id
    subscription_id     = module.management_subscription_association.subscription_id
  }
}

# IMPORTANT: Change to connectivity subscription later
output "platform_connectivity_subscription_association" {
  description = "Platform Connectivity subscription association details"
  value = {
    id                  = module.management_subscription_association.id
    management_group_id = module.management_subscription_association.management_group_id
    subscription_id     = module.management_subscription_association.subscription_id
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
