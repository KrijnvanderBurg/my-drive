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
    id = module.monitoring_alerts.action_group_id
  }
}

output "alert_rule_admin_activity" {
  description = "Administrative activity alert rule details"
  value = {
    id = module.monitoring_alerts.activity_log_alert_id
  }
}

output "monitoring_resource_group" {
  description = "Monitoring resource group name"
  value       = module.monitoring_alerts.resource_group_name
}
