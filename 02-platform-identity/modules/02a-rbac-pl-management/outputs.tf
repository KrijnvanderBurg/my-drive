# =============================================================================
# Outputs
# =============================================================================

output "role_assignment_ids" {
  description = "Map of role assignment keys to their resource IDs"
  value = {
    tenant_root_mg_contributor = azurerm_role_assignment.tenant_root_mg_contributor.id
    policy_contributor         = azurerm_role_assignment.policy_contributor.id
    tfstate                    = azurerm_role_assignment.tfstate.id
  }
}
