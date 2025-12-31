# =============================================================================
# Dev Environment - Management Groups
# =============================================================================

# Reference the existing Azure Tenant Root Group
data "azurerm_management_group" "tenant_root" {
  name = var.tenant_id
}

# Levendaal Group - organisational root management group
module "levendaal" {
  source = "../../modules/management-group"

  name                       = "mg-levendaal-${var.environment}-na-01"
  display_name               = "mg-levendaal-${var.environment}-na-01"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Sandbox Management Group - for development and testing
# Note: Sandbox is intentionally NOT protected to allow experimentation
module "sandbox" {
  source = "../../modules/management-group"

  name                       = "mg-sandbox-${var.environment}-na-01"
  display_name               = "mg-sandbox-${var.environment}-na-01"
  parent_management_group_id = module.levendaal.id
}

# Platform Management Group - platform management group
module "platform" {
  source = "../../modules/management-group"

  name                       = "mg-platform-${var.environment}-na-01"
  display_name               = "mg-platform-${var.environment}-na-01"
  parent_management_group_id = module.levendaal.id
}

# Platform management Management Group - for management resources
module "pl_management" {
  source = "../../modules/management-group"

  name                       = "mg-pl-management-${var.environment}-na-01"
  display_name               = "mg-pl-management-${var.environment}-na-01"
  parent_management_group_id = module.platform.id
}

# Platform connectivity Management Group - for management resources
module "pl_connectivity" {
  source = "../../modules/management-group"

  name                       = "mg-pl-connectivity-${var.environment}-na-01"
  display_name               = "mg-pl-connectivity-${var.environment}-na-01"
  parent_management_group_id = module.platform.id
}

# =============================================================================
# Policy Definitions
# =============================================================================

module "policy_deny_delete" {
  source = "../../modules/policy-deny-delete"

  name                = "deny-delete-operations"
  display_name        = "Deny Delete Operations"
  management_group_id = module.levendaal.id
}

# =============================================================================
# Policy Assignments
# =============================================================================

# Protect a management group from accidental deletions
resource "azurerm_management_group_policy_assignment" "platform_connectivity_deny_delete" {
  name                 = "deny-del-pl-connectivity"
  display_name         = "Deny Delete Operations - Platform Connectivity"
  description          = "Prevents deletion of any resources under platform connectivity management group"
  policy_definition_id = module.policy_deny_delete.id
  management_group_id  = module.pl_connectivity.id
  enforce              = true
}

# =============================================================================
# Subscription Associations
# =============================================================================

resource "azurerm_subscription" "platform_management" {
  alias             = "pl-management-co-dev-na-01"
  subscription_name = "pl-management-co-dev-na-01"
  subscription_id   = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
}

module "pl_management_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.pl_management.id
  subscription_id     = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
}

# =============================================================================
# Platform Connectivity Subscription
# =============================================================================

resource "azurerm_subscription" "platform_connectivity" {
  alias             = "pl-connectivity-co-dev-glb-01"
  subscription_name = "pl-connectivity-co-dev-glb-01"
  subscription_id   = "9312c5c5-b089-4b62-bb90-0d92d421d66c"
}

module "pl_connectivity_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.pl_connectivity.id
  subscription_id     = azurerm_subscription.platform_connectivity.subscription_id
}
