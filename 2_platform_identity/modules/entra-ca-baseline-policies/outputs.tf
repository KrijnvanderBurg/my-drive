output "block_legacy_auth" {
  description = "Block legacy authentication policy details"
  value = {
    id           = azuread_conditional_access_policy.block_legacy_auth.id
    display_name = azuread_conditional_access_policy.block_legacy_auth.display_name
    state        = azuread_conditional_access_policy.block_legacy_auth.state
  }
}

output "require_mfa" {
  description = "Require MFA for all users policy details"
  value = {
    id           = azuread_conditional_access_policy.require_mfa.id
    display_name = azuread_conditional_access_policy.require_mfa.display_name
    state        = azuread_conditional_access_policy.require_mfa.state
  }
}

output "require_mfa_azure_mgmt" {
  description = "Require MFA for Azure management policy details"
  value = {
    id           = azuread_conditional_access_policy.require_mfa_azure_mgmt.id
    display_name = azuread_conditional_access_policy.require_mfa_azure_mgmt.display_name
    state        = azuread_conditional_access_policy.require_mfa_azure_mgmt.state
  }
}

output "all_policies" {
  description = "All baseline policy IDs"
  value = {
    block_legacy_auth_id      = azuread_conditional_access_policy.block_legacy_auth.id
    require_mfa_id            = azuread_conditional_access_policy.require_mfa.id
    require_mfa_azure_mgmt_id = azuread_conditional_access_policy.require_mfa_azure_mgmt.id
  }
}
