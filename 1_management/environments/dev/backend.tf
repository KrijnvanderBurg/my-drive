terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev-gwc-01"
    storage_account_name = "sttfstatedevgwc01"
    container_name       = "tfstate-management"
    key                  = "management.opentofu.tfstate"
  }
}
