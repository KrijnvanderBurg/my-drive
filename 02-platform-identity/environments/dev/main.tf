# =============================================================================
# Service Principals (Federated for GitHub Actions)
# =============================================================================

module "sp_platform_management" {
  source = "../../modules/service-principal-federated"

  name = "sp-platform-management-co-${var.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

module "sp_alz_drives" {
  source = "../../modules/service-principal-federated"

  name = "sp-alz-drives-on-${var.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

# =============================================================================
# RBAC Role Assignments - Platform Management SP
# =============================================================================

# Management Group Contributor at tenant root - for reading tenant root and managing MG hierarchy
resource "azurerm_role_assignment" "sp_platform_management_tenant_root_mg_contributor" {
  scope                = data.terraform_remote_state.management.outputs.tenant_root_management_group_id
  role_definition_name = "Management Group Contributor"
  principal_id         = module.sp_platform_management.object_id
}

# Resource Policy Contributor for policy management
resource "azurerm_role_assignment" "sp_platform_management_policy_contributor" {
  scope                = data.terraform_remote_state.management.outputs.tenant_root_management_group_id
  role_definition_name = "Resource Policy Contributor"
  principal_id         = module.sp_platform_management.object_id
}

resource "azurerm_role_assignment" "sp_platform_management_tfstate" {
  scope                = data.terraform_remote_state.management.outputs.tfstate_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_platform_management.object_id
}

# =============================================================================
# RBAC Role Assignments - ALZ Drives SP
# =============================================================================

resource "azurerm_role_assignment" "sp_alz_drives_subscription_contributor" {
  scope                = data.terraform_remote_state.management.outputs.alz_drive_subscription.id
  role_definition_name = "Contributor"
  principal_id         = module.sp_alz_drives.object_id
}

resource "azurerm_role_assignment" "sp_alz_drives_tfstate" {
  scope                = data.terraform_remote_state.management.outputs.tfstate_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_alz_drives.object_id
}

# =============================================================================
# Security Groups
# =============================================================================

module "sg_rbac_platform_contributors" {
  source = "../../modules/entra-group"

  display_name       = "sg-rbac-platform-contributors-${var.environment}-na-01"
  description        = "Members have Contributor access to platform subscriptions via Azure RBAC"
  assignable_to_role = false
}

# =============================================================================
# Monitoring Alerts
# =============================================================================

module "monitoring_alerts" {
  source = "../../modules/monitoring-alerts"

  environment     = var.environment
  location        = local.location
  region          = local.region
  subscription_id = data.terraform_remote_state.management.outputs.pl_identity_subscription.subscription_id
  alert_email     = var.alert_email
  tags            = local.common_tags
}
