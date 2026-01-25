# =============================================================================
# Outputs
# =============================================================================

output "role_assignment_ids" {
  description = "Map of role assignment keys to their resource IDs"
  value = {
    subscription_contributor = azurerm_role_assignment.subscription_contributor.id
    plz_drives_contributor   = azurerm_role_assignment.plz_drives_contributor.id
    tfstate                  = azurerm_role_assignment.tfstate.id
  }
}
