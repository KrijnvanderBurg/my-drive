# -----------------------------------------------------------------------------
# Provider Configuration - Germany West Central Hub
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
  storage_use_azuread = true
  subscription_id     = data.terraform_remote_state.pl-management.outputs.pl_connectivity_subscription.subscription_id
}
