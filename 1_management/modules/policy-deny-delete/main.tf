# Policy definition to deny all delete operations
resource "azurerm_policy_definition" "deny_delete" {
  name                = "deny-delete-${var.name}"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Deny Delete Operations - ${var.display_name}"
  description         = "This policy denies all delete operations on resources for maximum protection."
  management_group_id = var.management_group_id

  metadata = jsonencode({
    category = "Protection"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          exists = "true"
        }
      ]
    }
    then = {
      effect = "denyAction"
      details = {
        actionNames = [
          "delete"
        ]
      }
    }
  })
}
