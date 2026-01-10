resource "azuread_application" "this" {
  display_name = var.name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_application_federated_identity_credential" "this" {
  for_each = { for idx, subject in var.subjects : idx => subject }

  application_id = azuread_application.this.id
  display_name   = "github-federation-${each.key}"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = each.value
  audiences      = ["api://AzureADTokenExchange"]
}
