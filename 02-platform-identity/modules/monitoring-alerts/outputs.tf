output "resource_group_name" {
  description = "Name of the monitoring resource group"
  value       = azurerm_resource_group.monitoring.name
}

output "action_group_id" {
  description = "ID of the action group"
  value       = azurerm_monitor_action_group.identity_alerts.id
}

output "activity_log_alert_id" {
  description = "ID of the activity log alert"
  value       = azurerm_monitor_activity_log_alert.admin_activity.id
}
