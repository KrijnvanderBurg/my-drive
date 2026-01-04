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
