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
  subscription_id     = "9312c5c5-b089-4b62-bb90-0d92d421d66c"
  storage_use_azuread = true
}

provider "azuread" {}

# =============================================================================
# Remote State Data Sources
# =============================================================================

data "terraform_remote_state" "management" {
  backend = "azurerm"

  config = {
    subscription_id      = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-management"
    key                  = "pl-management-dev.tfstate"
    use_azuread_auth     = true
  }
}
