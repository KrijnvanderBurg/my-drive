# =============================================================================
# Dev Environment - Management Groups
# =============================================================================

# Reference the existing Azure Tenant Root Group
data "azurerm_management_group" "tenant_root" {
  name = var.tenant_id
}

# Platform management Management Group - for management resources
module "management_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-pl-management-${var.environment}-na-01"
  display_name               = "mg-pl-management-${var.environment}-na-01"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Platform connectivity Management Group - for management resources
module "platform_connectivity_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-pl-platform-connectivity-${var.environment}-na-01"
  display_name               = "mg-pl-platform-connectivity-${var.environment}-na-01"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Sandbox Management Group - for development and testing
module "sandbox_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-sandbox-${var.environment}-na-01"
  display_name               = "mg-sandbox-${var.environment}-na-01"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# =============================================================================
# Policy Definitions
# =============================================================================

module "policy_deny_delete" {
  source = "../../modules/policy-deny-delete"

  name                = "deny-delete-platform"
  display_name        = "Deny Delete Operations - Platform"
  management_group_id = data.azurerm_management_group.tenant_root.id
}

# =============================================================================
# Policy Assignments
# =============================================================================

# Protect a management group from accidental deletions
resource "azurerm_management_group_policy_assignment" "platform_connectivity_deny_delete" {
  name                 = "deny-del-pl-connectivity"
  display_name         = "Deny Delete - Platform Connectivity"
  description          = "Prevents deletion of any resources under platform connectivity management group"
  policy_definition_id = module.policy_deny_delete.id
  management_group_id  = module.platform_connectivity_management_group.id
  enforce              = true
}

# Note: Sandbox is intentionally NOT protected to allow experimentation

# =============================================================================
# Subscription Associations
# =============================================================================
#
# IMPORTANT: The management subscription (e388ddce-c79d-4db0-8a6f-cd69b1708954) is the ONLY
# subscription created manually outside of Terraform. This is required because it
# contains the tfstate storage account used by this Terraform configuration.
# All other subscriptions MUST be created and associated via Terraform.
module "management_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.management_management_group.id
  subscription_id     = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
}

# =============================================================================
# Platform Connectivity Subscription
# =============================================================================

resource "azurerm_subscription" "platform_connectivity" {
  alias             = "pl-connectivity-co-dev-na-01"
  subscription_name = "pl-connectivity-co-dev-na-01"
  subscription_id   = "9312c5c5-b089-4b62-bb90-0d92d421d66c"
}

module "platform_connectivity_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.platform_connectivity_management_group.id
  subscription_id     = azurerm_subscription.platform_connectivity.subscription_id
}

# =============================================================================
# Billing Scopes (Microsoft Customer Agreement)
# =============================================================================
# Creates data sources for each billing scope defined in var.billing_scopes.
# Reference specific scopes when creating subscriptions:
#   billing_scope_id = data.azurerm_billing_mca_account_scope.billing["platform"].id
# =============================================================================
data "azurerm_billing_mca_account_scope" "billing" {
  for_each = var.billing_scopes

  billing_account_name = each.value.billing_account_name
  billing_profile_name = each.value.billing_profile_name
  invoice_section_name = each.value.invoice_section_name
}
