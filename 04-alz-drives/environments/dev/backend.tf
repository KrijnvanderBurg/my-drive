terraform {
  backend "azurerm" {
    subscription_id      = "e388ddce-c79d-4db0-8a6f-cd69b1708954"
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-alz-drive"
    use_azuread_auth     = true
  }
}
