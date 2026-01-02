tenant_id   = "90d27970-b92c-43dc-9935-1ed557d8e20e"
environment = "dev"

tags = {
  owner       = "kvdb"
  cost_center = "platform"
}

# =============================================================================
# Billing Configuration (Microsoft Customer Agreement)
# =============================================================================
# Define multiple billing scopes for different subscriptions.
# Get these values from Azure Portal > Cost Management + Billing > Billing scopes
#
# Usage: Reference by key when creating subscriptions, e.g.:
#   billing_scope_id = data.azurerm_billing_mca_account_scope.billing["platform"].id
# =============================================================================
billing_scopes = {
  # Infrastructure / shared services billing scope
  platform = {
    billing_account_name = "ffbe90e4-4c92-51f3-62db-7a172bf13a15:6bd78d7c-050e-43d3-b328-5b78d77bd526_2019-05-31"
    billing_profile_name = "DYXR-KFLN-BG7-PGB"
    invoice_section_name = "VD3P-IQFM-PJA-PGB"
  }
  # Add more billing scopes as needed, for example:
  # workload_a = {
  #   billing_account_name = "..."
  #   billing_profile_name = "..."
  #   invoice_section_name = "..."
  # }
}
