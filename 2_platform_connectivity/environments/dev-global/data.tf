# -----------------------------------------------------------------------------
# Remote State - Read Hub States
# -----------------------------------------------------------------------------

data "terraform_remote_state" "hub_gwc" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-co-dev-gwc-01"
    storage_account_name = "sttfstatecodevgwc01"
    container_name       = "tfstate-pl-connectivity"
    key                  = "pl-connectivity-gwc.tfstate"
  }
}

# Uncomment when second region is deployed
# data "terraform_remote_state" "hub_weu" {
#   backend = "azurerm"
#
#   config = {
#     resource_group_name  = "rg-tfstate-co-dev-gwc-01"
#     storage_account_name = "sttfstatecodevgwc01"
#     container_name       = "tfstate-pl-connectivity"
#     key                  = "pl-connectivity-weu.tfstate"
#   }
# }
