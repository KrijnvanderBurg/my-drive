resource "azurerm_resource_group" "monitoring" {
  name     = "rg-identity-monitoring-${var.environment}-${var.region}-01"
  location = var.location
  tags     = var.tags
}

resource "azurerm_monitor_action_group" "identity_alerts" {
  name                = "ag-identity-alerts-${var.environment}-${var.region}-01"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "id-alert"
  tags                = var.tags

  email_receiver {
    name                    = "security-team"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_activity_log_alert" "admin_activity" {
  name                = "alert-admin-activity-${var.environment}-${var.region}-01"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = "westeurope"
  scopes              = ["/subscriptions/${var.subscription_id}"]
  description         = "Alert on administrative role assignment changes in identity subscription"
  tags                = var.tags

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Authorization/roleAssignments/write"
    level          = "Informational"
  }

  action {
    action_group_id = azurerm_monitor_action_group.identity_alerts.id
  }

  enabled = true
}
