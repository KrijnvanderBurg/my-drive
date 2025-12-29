# -----------------------------------------------------------------------------
# Terraform Variables - Example Landing Zone - Dev
# -----------------------------------------------------------------------------

environment    = "dev"
location       = "germanywestcentral"
location_short = "gwc"
workload       = "exampleapp"
archetype      = "co"

address_space = ["10.10.0.0/24"]

subnets = {
  "snet-app-co-dev-gwc-01" = {
    address_prefixes  = ["10.10.0.0/26"]
    service_endpoints = []
  }
  "snet-data-co-dev-gwc-01" = {
    address_prefixes  = ["10.10.0.64/26"]
    service_endpoints = ["Microsoft.Storage"]
  }
}

tags = {
  project     = "example-app"
  environment = "dev"
  managed_by  = "opentofu"
  owner       = "app-team"
}
