terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14"
    }
  }

  backend "azurerm" {
    subscription_id      = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-connectivity"
    key                  = "pl-connectivity-dev-glb.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
  subscription_id     = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id
  storage_use_azuread = true
}

# =============================================================================
# Remote State - Platform Management
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
# Remote State - Regional Deployments
# =============================================================================

data "terraform_remote_state" "weu" {
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

data "terraform_remote_state" "gwc" {
  backend = "azurerm"

  config = {
    subscription_id      = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-connectivity"
    key                  = "pl-connectivity-dev-gwc.tfstate"
    use_azuread_auth     = true
  }
}
