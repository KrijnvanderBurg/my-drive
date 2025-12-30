# -----------------------------------------------------------------------------
# Provider Configuration - Global Connectivity
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57"
    }
  }
}

provider "azurerm" {
  features {}
  # Deploy to the permanent connectivity subscription (not PR-specific)
  subscription_id = data.terraform_remote_state.pl-management.outputs.platform_connectivity_subscription_association.subscription_id
}
