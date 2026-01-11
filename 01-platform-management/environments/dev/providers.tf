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

  tenant_id           = var.tenant_id
  subscription_id     = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
  storage_use_azuread = true
}
