tenant_id   = "90d27970-b92c-43dc-9935-1ed557d8e20e"
environment = "dev"

tags = {
  owner       = "kvdb"
  cost_center = "infra"
}

# =============================================================================
# Subscription IDs
# =============================================================================
# IMPORTANT: The management subscription is the ONLY subscription ID that should
# be hardcoded here. This subscription was created manually because it contains
# the tfstate storage account required for this Terraform configuration.
#
# All other subscriptions MUST be created via Terraform and referenced by their
# module outputs (e.g., module.some_subscription.id) - never hardcoded as variables.
# =============================================================================
management_subscription_id = "9312c5c5-b089-4b62-bb90-0d92d421d66c"
