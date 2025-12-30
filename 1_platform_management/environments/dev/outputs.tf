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

output "management_subscription_association" {
  description = "Management subscription association details"
  value = {
    id                  = module.management_subscription_association.id
    management_group_id = module.management_subscription_association.management_group_id
    subscription_id     = module.management_subscription_association.subscription_id
  }
}


# output "platform_connectivity_subscription" {
#   description = "Platform connectivity subscription details"
#   value = {
#     subscription_id = module.platform_connectivity_subscription.subscription_id
#     name            = module.platform_connectivity_subscription.name
#   }
# }

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
