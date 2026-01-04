# =============================================================================
# Named Location Outputs
# =============================================================================

output "named_location_trusted_ips" {
  description = "Trusted IPs named location details"
  value = {
    id           = module.nl_trusted_ips.id
    display_name = module.nl_trusted_ips.display_name
  }
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "breakglass_group" {
  description = "Break-glass exclusion group details"
  value = {
    id           = module.sg_breakglass.id
    display_name = module.sg_breakglass.display_name
  }
}

output "global_admins_group" {
  description = "Global administrators group details"
  value = {
    id           = module.sg_admins_global.id
    display_name = module.sg_admins_global.display_name
  }
}

output "platform_admins_group" {
  description = "Platform administrators group details"
  value = {
    id           = module.sg_admins_platform.id
    display_name = module.sg_admins_platform.display_name
  }
}

# =============================================================================
# Conditional Access Policy Outputs
# =============================================================================

output "ca_baseline_policies" {
  description = "All baseline Conditional Access policies"
  value       = module.ca_baseline_policies.all_policies
}

output "ca_policy_block_legacy_auth" {
  description = "Block legacy authentication CA policy details"
  value       = module.ca_baseline_policies.block_legacy_auth
}

output "ca_policy_require_mfa" {
  description = "Require MFA CA policy details"
  value       = module.ca_baseline_policies.require_mfa
}

output "ca_policy_require_mfa_azure_mgmt" {
  description = "Require MFA for Azure management CA policy details"
  value       = module.ca_baseline_policies.require_mfa_azure_mgmt
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

output "alert_rule_breakglass_signin" {
  description = "Break-glass sign-in alert rule details"
  value = {
    id   = azurerm_monitor_activity_log_alert.breakglass_signin.id
    name = azurerm_monitor_activity_log_alert.breakglass_signin.name
  }
}
