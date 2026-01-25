# Reference the existing Azure Tenant Root Group
data "azurerm_management_group" "tenant_root" {
  name = local.tenant_id
}

# =============================================================================
# Subscriptions
# =============================================================================
# Manually assigned subscriptions to management groups

data "azurerm_subscription" "platform_management" {
  subscription_id = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
}

data "azurerm_subscription" "platform_identity" {
  subscription_id = "9312c5c5-b089-4b62-bb90-0d92d421d66c"
}

data "azurerm_subscription" "platform_connectivity" {
  subscription_id = "6018b0fb-7b8c-491f-8abf-375d2c07ef97"
}

data "azurerm_subscription" "plz_drives" {
  subscription_id = "9af01e5c-f933-4b86-a389-a8ac837965a5"
}

data "azurerm_subscription" "alz_drive" {
  subscription_id = "4111975b-f6ca-4e08-b7b6-87d7b6c35840"
}

# Levendaal Group - organisational root management group
module "levendaal" {
  source = "../../modules/01-management-group"

  name                       = "mg-levendaal-${local.environment}-na-01"
  display_name               = "mg-levendaal-${local.environment}-na-01"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Sandbox Management Group - for development and testing
# Note: Sandbox is intentionally NOT protected to allow experimentation
module "sandbox" {
  source = "../../modules/01-management-group"

  name                       = "mg-sandbox-${local.environment}-na-01"
  display_name               = "mg-sandbox-${local.environment}-na-01"
  parent_management_group_id = module.levendaal.id
}

# Platform Management Group - platform management group
module "platform" {
  source = "../../modules/01-management-group"

  name                       = "mg-platform-${local.environment}-na-01"
  display_name               = "mg-platform-${local.environment}-na-01"
  parent_management_group_id = module.levendaal.id
}

# Platform management Management Group - for management resources
module "pl_management" {
  source = "../../modules/01-management-group"

  name                       = "mg-pl-management-${local.environment}-na-01"
  display_name               = "mg-pl-management-${local.environment}-na-01"
  parent_management_group_id = module.platform.id
}

# Platform identity Management Group - for identity resources
module "pl_identity" {
  source = "../../modules/01-management-group"

  name                       = "mg-pl-identity-${local.environment}-na-01"
  display_name               = "mg-pl-identity-${local.environment}-na-01"
  parent_management_group_id = module.platform.id
}

# Platform connectivity Management Group - for networking resources
module "pl_connectivity" {
  source = "../../modules/01-management-group"

  name                       = "mg-pl-connectivity-${local.environment}-na-01"
  display_name               = "mg-pl-connectivity-${local.environment}-na-01"
  parent_management_group_id = module.platform.id
}

# Landing Zone Management Group - for application workloads
module "landingzone" {
  source = "../../modules/01-management-group"

  name                       = "mg-landingzone-${local.environment}-na-01"
  display_name               = "mg-landingzone-${local.environment}-na-01"
  parent_management_group_id = module.levendaal.id
}

# =============================================================================
# Policy Definitions
# =============================================================================

module "policy_deny_delete" {
  source = "../../modules/02-policy-deny-delete"

  name                = "deny-delete-operations"
  display_name        = "Deny Delete Operations"
  management_group_id = module.levendaal.id
}

# =============================================================================
# Policy Assignments
# =============================================================================

# Protect a management group from accidental deletions
# resource "azurerm_management_group_policy_assignment" "platform_management_deny_delete" {
#   name                 = "deny-del-pl-management"
#   display_name         = "Deny Delete Operations - Platform Management"
#   description          = "Prevents deletion of any resources under platform management management group"
#   policy_definition_id = module.policy_deny_delete.id
#   management_group_id  = module.pl_management.id
#   enforce              = true
# }

# # Protect platform identity management group from accidental deletions
# resource "azurerm_management_group_policy_assignment" "platform_identity_deny_delete" {
#   name                 = "deny-del-pl-identity"
#   display_name         = "Deny Delete Operations - Platform Identity"
#   description          = "Prevents deletion of any resources under platform identity management group"
#   policy_definition_id = module.policy_deny_delete.id
#   management_group_id  = module.pl_identity.id
#   enforce              = true
# }

# # Protect platform connectivity management group from accidental deletions
# resource "azurerm_management_group_policy_assignment" "platform_connectivity_deny_delete" {
#   name                 = "deny-del-pl-connect"
#   display_name         = "Deny Delete Operations - Platform Connectivity"
#   description          = "Prevents deletion of any resources under platform connectivity management group"
#   policy_definition_id = module.policy_deny_delete.id
#   management_group_id  = module.pl_connectivity.id
#   enforce              = true
# }

# # Protect landing zone management group from accidental deletions
# resource "azurerm_management_group_policy_assignment" "landingzone_deny_delete" {
#   name                 = "deny-del-landingzone"
#   display_name         = "Deny Delete Operations - Landing Zone"
#   description          = "Prevents deletion of any resources under landing zone management group"
#   policy_definition_id = module.policy_deny_delete.id
#   management_group_id  = module.landingzone.id
#   enforce              = true
# }
