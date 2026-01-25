# =============================================================================
# Outputs
# =============================================================================

output "role_assignment_ids" {
  description = "Map of role assignment keys to their resource IDs"
  value = {
    subscription_contributor = azurerm_role_assignment.subscription_contributor.id
    subscription_uaa         = azurerm_role_assignment.subscription_uaa.id
    tfstate                  = azurerm_role_assignment.tfstate.id
    hub_vnet_peering         = azurerm_role_assignment.hub_vnet_peering.id
  }
}
