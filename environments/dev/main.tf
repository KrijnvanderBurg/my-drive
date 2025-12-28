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

  name                       = "mg-drive-prd-glb-01"
  display_name               = "drive"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Sandbox Management Group - for development and testing
module "sandbox_management_group" {
  source = "../../modules/management-group"

  name                       = "mg-sandbox-dev-glb-01"
  display_name               = "sandbox"
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# =============================================================================
# Subscription Associations
# =============================================================================

# Uncomment and configure when you have subscriptions to associate
# module "dev_subscription_association" {
#   source = "../../modules/subscription-association"
#
#   management_group_id = module.sandbox_management_group.id
#   subscription_id     = "/subscriptions/${var.dev_subscription_id}"
# }
