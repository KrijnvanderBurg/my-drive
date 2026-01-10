# =============================================================================
# Management Group Outputs
# =============================================================================

output "tenant_root_management_group_id" {
  description = "The fully qualified ID of the tenant root management group"
  value       = data.azurerm_management_group.tenant_root.id
}

output "levendaal_management_group" {
  description = "Levendaal root management group details"
  value = {
    id           = module.levendaal.id
    name         = module.levendaal.name
    display_name = module.levendaal.display_name
  }
}

output "sandbox_management_group" {
  description = "Sandbox management group details"
  value = {
    id           = module.sandbox.id
    name         = module.sandbox.name
    display_name = module.sandbox.display_name
  }
}

output "platform_management_group" {
  description = "Platform management group details"
  value = {
    id           = module.platform.id
    name         = module.platform.name
    display_name = module.platform.display_name
  }
}

output "platform_management_management_group" {
  description = "Platform Management management group details"
  value = {
    id           = module.pl_management.id
    name         = module.pl_management.name
    display_name = module.pl_management.display_name
  }
}

output "platform_identity_management_group" {
  description = "Platform Identity management group details"
  value = {
    id           = module.pl_identity.id
    name         = module.pl_identity.name
    display_name = module.pl_identity.display_name
  }
}

output "landingzone_management_group" {
  description = "Landing Zone management group details"
  value = {
    id           = module.landingzone.id
    name         = module.landingzone.name
    display_name = module.landingzone.display_name
  }
}

# =============================================================================
# Subscription Association Outputs
# =============================================================================

output "pl_management_subscription_association" {
  description = "Platform Management subscription association details"
  value = {
    id                  = module.pl_management_subscription_association.id
    management_group_id = module.pl_management_subscription_association.management_group_id
    subscription_id     = module.pl_management_subscription_association.subscription_id
  }
}

output "pl_identity_subscription_association" {
  description = "Platform Identity subscription association details"
  value = {
    id                  = module.pl_identity_subscription_association.id
    management_group_id = module.pl_identity_subscription_association.management_group_id
    subscription_id     = module.pl_identity_subscription_association.subscription_id
  }
}

output "alz_drive_subscription_association" {
  description = "ALZ Drive subscription association details"
  value = {
    id                  = module.alz_drive_subscription_association.id
    management_group_id = module.alz_drive_subscription_association.management_group_id
    subscription_id     = module.alz_drive_subscription_association.subscription_id
  }
}

output "pl_management_subscription" {
  description = "Platform Management subscription"
  value = {
    id              = azurerm_subscription.platform_management.id
    subscription_id = azurerm_subscription.platform_management.subscription_id
  }
}

output "pl_identity_subscription" {
  description = "Platform Identity subscription"
  value = {
    id              = azurerm_subscription.platform_identity.id
    subscription_id = azurerm_subscription.platform_identity.subscription_id
  }
}

output "alz_drive_subscription" {
  description = "ALZ Drive subscription"
  value = {
    id              = azurerm_subscription.alz_drive.id
    subscription_id = azurerm_subscription.alz_drive.subscription_id
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

# =============================================================================
# Terraform State Storage
# =============================================================================

output "tfstate_storage_account" {
  description = "Terraform state storage account details"
  value = {
    id                  = "/subscriptions/e388ddce-c79d-4db0-8a6f-cd69b1708954/resourceGroups/rg-tfstate-co-dev-gwc-01/providers/Microsoft.Storage/storageAccounts/sttfstatecodevgwc01"
    name                = "sttfstatecodevgwc01"
    resource_group_name = "rg-tfstate-co-dev-gwc-01"
    subscription_id     = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
  }
}
