# =============================================================================
# Azure Subscription
# =============================================================================
# Creates a new Azure subscription under a billing account and optionally
# associates it with a management group.
#
# Prerequisites:
# - Azure billing account with enrollment account (EA) or MCA billing profile
# - Service principal with Owner role on the enrollment account
#
# Usage:
#   module "my_subscription" {
#     source = "../../modules/subscription"
#
#     name             = "sub-myproject-dev-gwc-01"
#     billing_scope_id = module.billing.scope_id
#     management_group_id = module.my_management_group.id
#   }
# =============================================================================

resource "azurerm_subscription" "this" {
  subscription_name = var.name
  alias             = var.name
  billing_scope_id  = var.billing_scope_id

  tags = var.tags
}

resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = var.management_group_id
  subscription_id     = "/subscriptions/${azurerm_subscription.this.subscription_id}"
}
