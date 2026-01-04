# =============================================================================
# Baseline Conditional Access Policies
# Opinionated CA policies following Microsoft best practices and Zero Trust
# =============================================================================

# CA001: Block legacy authentication
resource "azuread_conditional_access_policy" "block_legacy_auth" {
  display_name = "CA001: Block legacy authentication"
  state        = var.policy_state

  conditions {
    client_app_types = ["exchangeActiveSync", "other"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = var.excluded_groups
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# CA002: Require MFA for all users
resource "azuread_conditional_access_policy" "require_mfa" {
  display_name = "CA002: Require MFA for all users"
  state        = var.policy_state

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = var.excluded_groups
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}

# CA003: Require MFA for Azure management
resource "azuread_conditional_access_policy" "require_mfa_azure_mgmt" {
  display_name = "CA003: Require MFA for Azure management"
  state        = var.policy_state

  conditions {
    client_app_types = ["all"]

    applications {
      # Azure management app ID (Microsoft Azure Management)
      included_applications = ["797f4846-ba00-4fd7-ba43-dac1f8f63013"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = var.excluded_groups
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}
