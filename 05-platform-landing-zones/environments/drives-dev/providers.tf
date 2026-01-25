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

  subscription_id     = local.subscription_id
  storage_use_azuread = true
}

provider "azurerm" {
  alias = "connectivity"
  features {}

  subscription_id     = local.connectivity_subscription_id
  storage_use_azuread = true
}

# =============================================================================
# Remote State - Management Layer
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

# =============================================================================
# Remote State - Connectivity Layer (WEU)
# =============================================================================

data "terraform_remote_state" "connectivity_weu" {
  backend = "azurerm"

  config = {
    subscription_id      = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-connectivity"
    key                  = "pl-connectivity-dev-weu.tfstate"
    use_azuread_auth     = true
  }
}
