# =============================================================================
# Service Principals (Federated for GitHub Actions)
# =============================================================================
module "sp_platform_management" {
  source = "../../modules/01-service-principal-federated"

  name = "sp-plmanagement-co-${local.environment}-na-01"
  subjects = [
    "repo:KrijnvanderBurg/my-cloud:environment:dev"
  ]
}

# =============================================================================
# Service Principals
# =============================================================================
# No SP for platform identity, using manual SP instead to avoid circular dependencies
# and Identity has elevated permissions that we don't want to automate creation for.

module "sp_platform_connectivity" {
  source = "../../modules/01-service-principal-federated"

  name = "sp-pl-connectivity-on-${local.environment}-na-01"
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
# RBAC Role Assignments
# =============================================================================
module "rbac_platform_management" {
  source = "../../modules/02a-rbac-pl-management"

  principal_id                    = module.sp_platform_management.object_id
  tenant_root_management_group_id = local.tenant_root_management_group_id
  tfstate_storage_account_id      = local.tfstate_storage_account_id

  depends_on = [module.sp_platform_management]
}

module "rbac_platform_connectivity" {
  source = "../../modules/02b-rbac-pl-connectivity"

  principal_id                       = module.sp_platform_connectivity.object_id
  pl_connectivity_subscription_scope = local.pl_connectivity_subscription_scope
  plz_drives_subscription_scope      = local.plz_drives_subscription_scope
  tfstate_storage_account_id         = local.tfstate_storage_account_id

  depends_on = [module.sp_platform_connectivity]
}

module "rbac_alz_drives" {
  source = "../../modules/02c-rbac-alz-drives"

  principal_id                 = module.sp_alz_drives.object_id
  alz_drive_subscription_scope = local.alz_drive_subscription_scope
  tfstate_storage_account_id   = local.tfstate_storage_account_id

  depends_on = [module.sp_alz_drives]
}

module "rbac_plz_drives" {
  source = "../../modules/02d-rbac-plz"

  principal_id                  = module.sp_plz_drives.object_id
  plz_drives_subscription_scope = local.plz_drives_subscription_scope
  tfstate_storage_account_id    = local.tfstate_storage_account_id

  depends_on = [module.sp_plz_drives]
}

# =============================================================================
# Security Groups
# =============================================================================
module "sg_rbac_platform_contributors" {
  source = "../../modules/06-entra-group"

  display_name       = "sg-rbac-pl-contributors-${local.environment}-na-01"
  description        = "Members have Contributor access to platform subscriptions via Azure RBAC"
  assignable_to_role = false
}

# =============================================================================
# Monitoring Alerts
# =============================================================================
module "monitoring_alerts" {
  source = "../../modules/07-monitoring-alerts"

  environment     = local.environment
  location        = local.location
  location_short  = local.location_short
  subscription_id = local.pl_identity_subscription_id
  alert_email     = local.alert_email
  tags            = local.common_tags
}
