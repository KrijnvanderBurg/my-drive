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

# Platform identity Management Group - for identity resources
module "pl_identity" {
  source = "../../modules/management-group"

  name                       = "mg-pl-identity-${var.environment}-na-01"
  display_name               = "mg-pl-identity-${var.environment}-na-01"
  parent_management_group_id = module.platform.id
}

# Landing Zone Management Group - for application workloads
module "landingzone" {
  source = "../../modules/management-group"

  name                       = "mg-landingzone-${var.environment}-na-01"
  display_name               = "mg-landingzone-${var.environment}-na-01"
  parent_management_group_id = module.levendaal.id
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
resource "azurerm_management_group_policy_assignment" "platform_management_deny_delete" {
  name                 = "deny-del-pl-management"
  display_name         = "Deny Delete Operations - Platform Management"
  description          = "Prevents deletion of any resources under platform management management group"
  policy_definition_id = module.policy_deny_delete.id
  management_group_id  = module.pl_management.id
  enforce              = true
}

# Protect landing zone management group from accidental deletions
resource "azurerm_management_group_policy_assignment" "landingzone_deny_delete" {
  name                 = "deny-del-landingzone"
  display_name         = "Deny Delete Operations - Landing Zone"
  description          = "Prevents deletion of any resources under landing zone management group"
  policy_definition_id = module.policy_deny_delete.id
  management_group_id  = module.landingzone.id
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
# Platform Identity Subscription
# =============================================================================

resource "azurerm_subscription" "platform_identity" {
  alias             = "pl-identity-co-dev-na-01"
  subscription_name = "pl-identity-co-dev-na-01"
  subscription_id   = "9312c5c5-b089-4b62-bb90-0d92d421d66c"
}

module "pl_identity_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.pl_identity.id
  subscription_id     = azurerm_subscription.platform_identity.subscription_id
}

# =============================================================================
# Drive Subscription
# =============================================================================

resource "azurerm_subscription" "alz_drive" {
  alias             = "alz-drive-on-dev-na-01"
  subscription_name = "alz-drive-on-dev-na-01"
  subscription_id   = "4111975b-f6ca-4e08-b7b6-87d7b6c35840"
}

module "alz_drive_subscription_association" {
  source = "../../modules/subscription-association"

  management_group_id = module.landingzone.id
  subscription_id     = azurerm_subscription.alz_drive.subscription_id
}
