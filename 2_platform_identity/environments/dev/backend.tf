terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-identity"
  }
}
