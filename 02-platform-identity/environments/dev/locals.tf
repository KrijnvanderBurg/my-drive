# =============================================================================
# Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State References
  # ---------------------------------------------------------------------------
  tenant_id                       = data.terraform_remote_state.management.outputs.tenant_id
  tenant_root_management_group_id = data.terraform_remote_state.management.outputs.tenant_root_management_group_id
  tfstate_storage_account_id      = data.terraform_remote_state.management.outputs.tfstate_storage_account.id

  # ---------------------------------------------------------------------------
  # Subscription Scopes (full paths for role assignment scopes)
  # ---------------------------------------------------------------------------
  pl_management_subscription_scope   = data.terraform_remote_state.management.outputs.pl_management_subscription.id
  pl_identity_subscription_scope     = data.terraform_remote_state.management.outputs.pl_identity_subscription.id
  pl_connectivity_subscription_scope = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.id
  plz_drives_subscription_scope      = data.terraform_remote_state.management.outputs.plz_drives_subscription.id
  alz_drive_subscription_scope       = data.terraform_remote_state.management.outputs.alz_drive_subscription.id

  # Subscription IDs (UUIDs only)
  pl_management_subscription_id   = data.terraform_remote_state.management.outputs.pl_management_subscription.subscription_id
  pl_identity_subscription_id     = data.terraform_remote_state.management.outputs.pl_identity_subscription.subscription_id
  pl_connectivity_subscription_id = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id
  plz_drives_subscription_id      = data.terraform_remote_state.management.outputs.plz_drives_subscription.subscription_id
  alz_drive_subscription_id       = data.terraform_remote_state.management.outputs.alz_drive_subscription.subscription_id

  # ---------------------------------------------------------------------------
  # location_short Configuration
  # ---------------------------------------------------------------------------
  environment    = "dev"
  location_short = "gwc"
  location       = "germanywestcentral"

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
