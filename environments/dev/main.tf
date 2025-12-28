# =============================================================================
# Dev Environment - Management Groups
# =============================================================================

# Reference the existing Azure Tenant Root Group
data "azurerm_management_group" "tenant_root" {
  name = var.tenant_id
}

# Drive Management Group - for shared drive services
module "drive_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-drive-${var.environment}-glb-01"
  display_name               = "drive"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Sandbox Management Group - for development and testing
module "sandbox_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-sandbox-${var.environment}-glb-01"
  display_name               = "sandbox"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Management Management Group - for management resources
module "management_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-management-${var.environment}-glb-01"
  display_name               = "management"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# =============================================================================
# Policy Definitions
# =============================================================================

module "policy_deny_delete" {
  source = "../../modules/policy-deny-delete"

  name                = "deny-delete"
  display_name        = "Deny Delete"
  management_group_id = data.azurerm_management_group.tenant_root.id
}

# =============================================================================
# Policy Assignments
# =============================================================================

# Protect drive management group from accidental deletions
resource "azurerm_management_group_policy_assignment" "drive_deny_delete" {
  name                 = "deny-del-drive"
  display_name         = "Deny Delete - Drive"
  description          = "Prevents deletion of any resources under drive management group"
  policy_definition_id = module.policy_deny_delete.id
  management_group_id  = module.drive_management_group.id
  enforce              = true
}

# Note: Sandbox is intentionally NOT protected to allow experimentation

# =============================================================================
# Subscription Associations
# =============================================================================
#
# IMPORTANT: The management subscription (sub-management-${var.environment}-gwc-01) is the ONLY
# subscription created manually outside of Terraform. This is required because it
# contains the tfstate storage account used by this Terraform configuration.
# All other subscriptions MUST be created and associated via Terraform.
module "management_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.management_management_group.id
  subscription_id     = var.management_subscription_id
}

# =============================================================================
# Subscriptions
# =============================================================================
module "drive_subscription" {
  source              = "../../modules/subscription"
  name                = "sub-drive-${var.environment}-gwc-01"
  billing_scope_id    = "/providers/Microsoft.Billing/billingAccounts/ffbe90e4-4c92-51f3-62db-7a172bf13a15:6bd78d7c-050e-43d3-b328-5b78d77bd526_2019-05-31/billingProfiles/DYXR-KFLN-BG7-PGB/invoiceSections/VD3P-IQFM-PJA-PGB"
  management_group_id = module.drive_management_group.id
  tags                = var.tags
}
