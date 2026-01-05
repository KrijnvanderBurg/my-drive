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

  subscription_id     = "9af01e5c-f933-4b86-a389-a8ac837965a5"
  storage_use_azuread = true
}
