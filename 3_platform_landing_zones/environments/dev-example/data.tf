# -----------------------------------------------------------------------------
# Remote State - Read Hub State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "hub" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-connectivity"
    key                  = "pl-connectivity-gwc.tfstate"
  }
}
