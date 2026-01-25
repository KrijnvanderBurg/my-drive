resource "azuread_group" "this" {
  display_name            = var.display_name
  description             = var.description
  security_enabled        = true
  assignable_to_role      = var.assignable_to_role
  prevent_duplicate_names = true
}
