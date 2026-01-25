# =============================================================================
# Service Principals (Federated for GitHub Actions)
# =============================================================================
module "sp_platform_management" {
  source = "../../modules/01-service-principal-federated"

  name = "sp-platform-management-co-${local.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

# No SP for platform identity, using manual SP instead to avoid circular dependencies
# and Identity has elevated permissions that we don't want to automate creation for.

module "sp_platform_connectivity" {
  source = "../../modules/01-service-principal-federated"

  name = "sp-platform-connectivity-on-${local.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

module "sp_alz_drives" {
  source = "../../modules/01-service-principal-federated"

  name = "sp-alz-drives-on-${local.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

module "sp_plz_drives" {
  source = "../../modules/01-service-principal-federated"

  name = "sp-plz-drives-on-${local.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

# =============================================================================
# RBAC Role Assignments - Platform Management SP
# =============================================================================

# Management Group Contributor at tenant root - for reading tenant root and managing MG hierarchy
resource "azurerm_role_assignment" "sp_platform_management_tenant_root_mg_contributor" {
  scope                = local.tenant_root_management_group_id
  role_definition_name = "Management Group Contributor"
  principal_id         = module.sp_platform_management.object_id
}

# Resource Policy Contributor for policy management
resource "azurerm_role_assignment" "sp_platform_management_policy_contributor" {
  scope                = local.tenant_root_management_group_id
  role_definition_name = "Resource Policy Contributor"
  principal_id         = module.sp_platform_management.object_id
}

resource "azurerm_role_assignment" "sp_platform_management_tfstate" {
  scope                = local.tfstate_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_platform_management.object_id
}

# =============================================================================
# RBAC Role Assignments - ALZ Drives SP
# =============================================================================
resource "azurerm_role_assignment" "sp_alz_drives_subscription_contributor" {
  scope                = local.alz_drive_subscription_scope
  role_definition_name = "Contributor"
  principal_id         = module.sp_alz_drives.object_id
}

# User Access Administrator role for creating management locks
resource "azurerm_role_assignment" "sp_alz_drives_subscription_uaa" {
  scope                = local.alz_drive_subscription_scope
  role_definition_name = "User Access Administrator"
  principal_id         = module.sp_alz_drives.object_id
}

resource "azurerm_role_assignment" "sp_alz_drives_tfstate" {
  scope                = local.tfstate_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_alz_drives.object_id
}

# =============================================================================
# RBAC Role Assignments - Platform Connectivity SP
# =============================================================================

resource "azurerm_role_assignment" "sp_platform_connectivity_subscription_contributor" {
  scope                = local.pl_connectivity_subscription_scope
  role_definition_name = "Contributor"
  principal_id         = module.sp_platform_connectivity.object_id
}

# Connectivity SP needs Contributor on PLZ Drives subscription to create spoke VNet
resource "azurerm_role_assignment" "sp_platform_connectivity_plz_drives_contributor" {
  scope                = local.plz_drives_subscription_scope
  role_definition_name = "Contributor"
  principal_id         = module.sp_platform_connectivity.object_id
}

resource "azurerm_role_assignment" "sp_platform_connectivity_tfstate" {
  scope                = local.tfstate_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_platform_connectivity.object_id
}

# # =============================================================================
# # RBAC Role Assignments - PLZ Drives SP
# # =============================================================================

# resource "azurerm_role_assignment" "sp_plz_drives_subscription_contributor" {
#   scope                = local.plz_drives_subscription_scope
#   role_definition_name = "Contributor"
#   principal_id         = module.sp_plz_drives.object_id
# }

# resource "azurerm_role_assignment" "sp_plz_drives_subscription_uaa" {
#   scope                = local.plz_drives_subscription_scope
#   role_definition_name = "User Access Administrator"
#   principal_id         = module.sp_plz_drives.object_id
# }

# resource "azurerm_role_assignment" "sp_plz_drives_tfstate" {
#   scope                = local.tfstate_storage_account_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = module.sp_plz_drives.object_id
# }

# =============================================================================
# Security Groups
# =============================================================================
module "sg_rbac_platform_contributors" {
  source = "../../modules/02-entra-group"

  display_name       = "sg-rbac-platform-contributors-${local.environment}-na-01"
  description        = "Members have Contributor access to platform subscriptions via Azure RBAC"
  assignable_to_role = false
}

# =============================================================================
# Monitoring Alerts
# =============================================================================
module "monitoring_alerts" {
  source = "../../modules/03-monitoring-alerts"

  environment     = local.environment
  location        = local.location
  location_short  = local.location_short
  subscription_id = local.pl_identity_subscription_id
  alert_email     = local.alert_email
  tags            = local.common_tags
}
