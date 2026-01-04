# =============================================================================
# Named Location - Trusted IPs
# =============================================================================

module "nl_trusted_ips" {
  source = "../../modules/entra-named-location"

  display_name = "nl-trusted-ips-${var.environment}-na-01"
  ip_ranges    = var.trusted_ips
  trusted      = true
}

# =============================================================================
# Security Groups
# =============================================================================

module "sg_breakglass" {
  source = "../../modules/entra-group"

  display_name       = "sg-ca-exclude-breakglass-${var.environment}-na-01"
  description        = "Emergency break-glass accounts excluded from all Conditional Access policies"
  assignable_to_role = true
}

module "sg_admins_global" {
  source = "../../modules/entra-group"

  display_name       = "sg-admins-global-${var.environment}-na-01"
  description        = "Global administrators with tenant-wide permissions"
  assignable_to_role = true
}

module "sg_admins_platform" {
  source = "../../modules/entra-group"

  display_name       = "sg-admins-platform-${var.environment}-na-01"
  description        = "Platform administrators for Azure landing zone management"
  assignable_to_role = true
}

# =============================================================================
# Conditional Access Policies - Baseline
# =============================================================================

module "ca_baseline_policies" {
  source = "../../modules/entra-ca-baseline-policies"

  policy_state = "enabledForReportingButNotEnforced"
  excluded_groups = [
    module.sg_breakglass.id
  ]
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
}

# =============================================================================
# Monitoring - Break-glass Sign-in Alert
# =============================================================================

resource "azurerm_monitor_activity_log_alert" "breakglass_signin" {
  name                = "alert-breakglass-signin-${var.environment}-${local.region}-01"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = local.location
  scopes              = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"]
  description         = "Critical alert: Emergency break-glass account sign-in detected"
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
}

# =============================================================================
# Data Sources
# =============================================================================

data "azurerm_client_config" "current" {}
