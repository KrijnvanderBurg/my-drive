# -----------------------------------------------------------------------------
# Remote State - Read Management Layer State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "pl-management" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-management"
    key                  = "pl-management-dev.tfstate"
  }
}
