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

  subscription_id     = "4111975b-f6ca-4e08-b7b6-87d7b6c35840"
  storage_use_azuread = true
}
