# =============================================================================
# Service Principal Outputs
# =============================================================================

output "sp_platform_management" {
  description = "Platform management service principal for GitHub Actions OIDC"
  value = {
    client_id    = module.sp_platform_management.client_id
    object_id    = module.sp_platform_management.object_id
    display_name = module.sp_platform_management.display_name
  }
}

output "sp_alz_drives" {
  description = "ALZ drives service principal for GitHub Actions OIDC"
  value = {
    client_id    = module.sp_alz_drives.client_id
    object_id    = module.sp_alz_drives.object_id
    display_name = module.sp_alz_drives.display_name
  }
}

output "sp_platform_connectivity" {
  description = "Platform connectivity service principal for GitHub Actions OIDC"
  value = {
    client_id    = module.sp_platform_connectivity.client_id
    object_id    = module.sp_platform_connectivity.object_id
    display_name = module.sp_platform_connectivity.display_name
  }
}

output "sp_plz_drives" {
  description = "PLZ drives service principal for GitHub Actions OIDC"
  value = {
    client_id    = module.sp_plz_drives.client_id
    object_id    = module.sp_plz_drives.object_id
    display_name = module.sp_plz_drives.display_name
  }
}

# =============================================================================
# RBAC Role Assignment Outputs
# =============================================================================

output "rbac_platform_management" {
  description = "Role assignment IDs for platform management service principal"
  value       = module.rbac_platform_management.role_assignment_ids
}

output "rbac_platform_connectivity" {
  description = "Role assignment IDs for platform connectivity service principal"
  value       = module.rbac_platform_connectivity.role_assignment_ids
}

output "rbac_plz_drives" {
  description = "Role assignment IDs for PLZ drives service principal"
  value       = module.rbac_plz_drives.role_assignment_ids
}

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
