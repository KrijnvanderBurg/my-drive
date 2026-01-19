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

  subscription_id     = local.connectivity_subscription_id
  storage_use_azuread = true
}

# =============================================================================
# Remote State - Management Layer
# =============================================================================

data "terraform_remote_state" "management" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-terraform-state-on-dev-glb-01"
    storage_account_name = "sttfstateondevglb01"
    container_name       = "tfstate"
    key                  = "02-platform-management/dev-glb.tfstate"
  }
}

# =============================================================================
# Remote State - GWC Region
# =============================================================================

data "terraform_remote_state" "gwc" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-terraform-state-on-dev-glb-01"
    storage_account_name = "sttfstateondevglb01"
    container_name       = "tfstate"
    key                  = "03-platform-connectivity/dev-gwc.tfstate"
  }
}