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
# Monitoring - Action Group
# =============================================================================

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-identity-monitoring-${var.environment}-${local.region}-01"
  location = local.location
  tags     = local.common_tags
}

resource "azurerm_monitor_action_group" "identity_alerts" {
  name                = "ag-identity-alerts-${var.environment}-${local.region}-01"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "id-alert"
  tags                = local.common_tags

  email_receiver {
    name                    = "security-team"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  depends_on = [azurerm_resource_group.monitoring]
}

# =============================================================================
# Monitoring - Administrative Activity Alert
# =============================================================================

resource "azurerm_monitor_activity_log_alert" "admin_activity" {
  name                = "alert-admin-activity-${var.environment}-${local.region}-01"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = "westeurope"
  scopes              = ["/subscriptions/${data.terraform_remote_state.management.outputs.pl_identity_subscription.subscription_id}"]
  description         = "Alert on administrative role assignment changes in identity subscription"
  tags                = local.common_tags

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Authorization/roleAssignments/write"
    level          = "Informational"
  }

  action {
    action_group_id = azurerm_monitor_action_group.identity_alerts.id
  }

  enabled = true

  depends_on = [
    azurerm_resource_group.monitoring,
    azurerm_monitor_action_group.identity_alerts
  ]
}
