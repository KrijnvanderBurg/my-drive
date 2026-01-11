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

module "sp_platform_identity" {
  source = "../../modules/service-principal-federated"

  name = "sp-platform-identity-co-${var.environment}-na-01"
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

resource "azurerm_role_assignment" "sp_platform_management_mg_contributor" {
  scope                = data.terraform_remote_state.management.outputs.levendaal_management_group.id
  role_definition_name = "Management Group Contributor"
  principal_id         = module.sp_platform_management.object_id
}

resource "azurerm_role_assignment" "sp_platform_management_policy_contributor" {
  scope                = data.terraform_remote_state.management.outputs.levendaal_management_group.id
  role_definition_name = "Resource Policy Contributor"
  principal_id         = module.sp_platform_management.object_id
}

resource "azurerm_role_assignment" "sp_platform_management_tfstate" {
  scope                = data.terraform_remote_state.management.outputs.tfstate_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_platform_management.object_id
}

# =============================================================================
# RBAC Role Assignments - Platform Identity SP
# =============================================================================

resource "azurerm_role_assignment" "sp_platform_identity_subscription_contributor" {
  scope                = "/subscriptions/${data.terraform_remote_state.management.outputs.pl_identity_subscription.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.sp_platform_identity.object_id
}

resource "azurerm_role_assignment" "sp_platform_identity_tfstate" {
  scope                = data.terraform_remote_state.management.outputs.tfstate_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_platform_identity.object_id
}

# =============================================================================
# RBAC Role Assignments - ALZ Drives SP
# =============================================================================

resource "azurerm_role_assignment" "sp_alz_drives_subscription_contributor" {
  scope                = "/subscriptions/${data.terraform_remote_state.management.outputs.alz_drive_subscription.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.sp_alz_drives.object_id
}

resource "azurerm_role_assignment" "sp_alz_drives_tfstate" {
  scope                = data.terraform_remote_state.management.outputs.tfstate_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.sp_alz_drives.object_id
}

# =============================================================================
# Graph API Permissions - Platform Identity SP
# =============================================================================

# Reference the Microsoft Graph service principal
data "azuread_service_principal" "msgraph" {
  client_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
}

# Declare the API permissions on the application
resource "azuread_application_api_access" "sp_platform_identity_graph" {
  application_id = module.sp_platform_identity.application_id
  api_client_id  = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

  role_ids = [
    "18a4783c-866b-4cc7-a460-3d5e5662c884", # Application.ReadWrite.OwnedBy
    "62a82d76-70ea-41e2-9197-370581804d09", # Group.ReadWrite.All
    "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8", # RoleManagement.ReadWrite.Directory
  ]
}

# Grant admin consent by assigning app roles to the service principal
resource "azuread_app_role_assignment" "sp_platform_identity_application_readwrite" {
  app_role_id         = "18a4783c-866b-4cc7-a460-3d5e5662c884" # Application.ReadWrite.OwnedBy
  principal_object_id = module.sp_platform_identity.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "sp_platform_identity_group_readwrite" {
  app_role_id         = "62a82d76-70ea-41e2-9197-370581804d09" # Group.ReadWrite.All
  principal_object_id = module.sp_platform_identity.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "sp_platform_identity_rolemanagement" {
  app_role_id         = "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8" # RoleManagement.ReadWrite.Directory
  principal_object_id = module.sp_platform_identity.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
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
