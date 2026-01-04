# =============================================================================
# Security Group Outputs
# =============================================================================

output "sg_rbac_platform_contributors" {
  description = "Platform contributors security group for Azure RBAC assignments"
  value = {
    id           = module.sg_rbac_platform_contributors.id
    object_id    = module.sg_rbac_platform_contributors.object_id
    display_name = module.sg_rbac_platform_contributors.display_name
  }
}

# =============================================================================
# Monitoring Outputs
# =============================================================================

output "action_group_identity_alerts" {
  description = "Identity alerts action group details"
  value = {
    id   = azurerm_monitor_action_group.identity_alerts.id
    name = azurerm_monitor_action_group.identity_alerts.name
  }
}

output "alert_rule_admin_activity" {
  description = "Administrative activity alert rule details"
  value = {
    id   = azurerm_monitor_activity_log_alert.admin_activity.id
    name = azurerm_monitor_activity_log_alert.admin_activity.name
  }
}
