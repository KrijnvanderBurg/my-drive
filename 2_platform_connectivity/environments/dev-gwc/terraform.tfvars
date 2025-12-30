# -----------------------------------------------------------------------------
# Terraform Variables - Germany West Central Hub - Dev
# -----------------------------------------------------------------------------

environment    = "dev"
location       = "germanywestcentral"
location_short = "gwc"

# Hub Network
hub_address_space = ["10.0.0.0/16"]
subnet_nva        = "10.0.0.0/24"
subnet_management = "10.0.1.0/24"
subnet_jumpbox    = "10.0.2.0/24"

# NVA IPs
nva_primary_ip   = "10.0.0.4"
nva_secondary_ip = "10.0.0.5"
nva_lb_ip        = "10.0.0.6"

# Platform Spokes
identity_spoke_address_space   = ["10.1.0.0/24"]
management_spoke_address_space = ["10.2.0.0/24"]

tags = {
  project     = "levendaal"
  environment = "dev"
  managed_by  = "opentofu"
}
