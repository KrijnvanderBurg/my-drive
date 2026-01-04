terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id     = data.terraform_remote_state.management.outputs.pl_identity_subscription.subscription_id
  storage_use_azuread = true
}

provider "azuread" {
  # tenant_id automatically derived from Azure CLI/environment authentication
}

# =============================================================================
# Remote State Data Sources
# =============================================================================

data "terraform_remote_state" "management" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-management"
    key                  = "pl-management-dev.tfstate"
  }
}
