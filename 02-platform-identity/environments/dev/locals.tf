# =============================================================================
# Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  tenant_root_management_group_id     = data.terraform_remote_state.management.outputs.tenant_root_management_group_id
  tfstate_storage_account_id          = data.terraform_remote_state.management.outputs.tfstate_storage_account.id
  alz_drive_subscription_id           = data.terraform_remote_state.management.outputs.alz_drive_subscription.id
  pl_identity_subscription_id         = data.terraform_remote_state.management.outputs.pl_identity_subscription.subscription_id
  pl_connectivity_subscription_id     = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.id
  pl_connectivity_management_group_id = data.terraform_remote_state.management.outputs.platform_connectivity_management_group.id

  # ---------------------------------------------------------------------------
  # Region Configuration
  # ---------------------------------------------------------------------------
  environment = "dev"
  region      = "gwc"
  location    = "germanywestcentral"

  # ---------------------------------------------------------------------------
  # Common Tags
  # ---------------------------------------------------------------------------
  common_tags = {
    environment = local.environment
    managed_by  = "opentofu"
    project     = "levendaal"
    layer       = "platform-identity"
    cost_center = "platform"
    owner       = "platform-team"
  }

  # ---------------------------------------------------------------------------
  # Alerts Configuration
  # ---------------------------------------------------------------------------
  alert_email = "krijnvdburg@protonmail.com"
}
