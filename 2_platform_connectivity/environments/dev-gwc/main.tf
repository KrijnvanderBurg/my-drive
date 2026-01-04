# -----------------------------------------------------------------------------
# Regional Hub - Germany West Central
# -----------------------------------------------------------------------------
# This deployment creates the regional hub for GWC:
# - Hub VNet with subnets for Bastion, Gateway, and Management
# - Route table with default route blocking internet (next hop = None)
# - Private DNS zone links to global DNS zones
#
# Internet is blocked by default via route table (0.0.0.0/0 -> None).
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Hub VNet
# -----------------------------------------------------------------------------

module "hub_vnet" {
  source = "../../modules/hub-vnet"

  resource_group_name = "rg-connectivity-co-${local.environment}-${local.location_short}-01"
  location            = local.location
  vnet_name           = "vnet-hub-co-${local.environment}-${local.location_short}-01"
  address_space       = local.hub_address_space

  subnets = {
    "GatewaySubnet" = {
      address_prefixes  = ["10.100.0.0/27"] # 10.100.0.0 - 10.100.0.31
      service_endpoints = []
    }
    "AzureBastionSubnet" = {
      address_prefixes  = ["10.100.0.32/27"] # 10.100.0.32 - 10.100.0.63
      service_endpoints = []
    }
    "snet-mgmt-co-${local.environment}-${local.location_short}-01" = {
      address_prefixes  = ["10.100.0.64/28"] # 10.100.0.64 - 10.100.0.79
      service_endpoints = []
    }
  }

  tags = local.tags
}

# -----------------------------------------------------------------------------
# Route Table - Blocks Internet by Default
# -----------------------------------------------------------------------------

resource "azurerm_route_table" "hub" {
  name                = "rt-hub-co-${local.environment}-${local.location_short}-01"
  location            = local.location
  resource_group_name = module.hub_vnet.hub_resource_group_name
  tags                = local.tags

  # Default route - drops all internet-bound traffic
  route {
    name           = "default-deny-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "None"
  }
}

# -----------------------------------------------------------------------------
# Private DNS Zone Links
# -----------------------------------------------------------------------------

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-blob-hub-${local.location_short}"
  resource_group_name   = split("/", data.terraform_remote_state.connectivity-global.outputs.dns_zone_blob_id)[4]
  private_dns_zone_name = data.terraform_remote_state.connectivity-global.outputs.dns_zone_blob_name
  virtual_network_id    = module.hub_vnet.hub_vnet_id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "link-keyvault-hub-${local.location_short}"
  resource_group_name   = split("/", data.terraform_remote_state.connectivity-global.outputs.dns_zone_keyvault_id)[4]
  private_dns_zone_name = data.terraform_remote_state.connectivity-global.outputs.dns_zone_keyvault_name
  virtual_network_id    = module.hub_vnet.hub_vnet_id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "file" {
  name                  = "link-file-hub-${local.location_short}"
  resource_group_name   = split("/", data.terraform_remote_state.connectivity-global.outputs.dns_zone_file_id)[4]
  private_dns_zone_name = data.terraform_remote_state.connectivity-global.outputs.dns_zone_file_name
  virtual_network_id    = module.hub_vnet.hub_vnet_id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue" {
  name                  = "link-queue-hub-${local.location_short}"
  resource_group_name   = split("/", data.terraform_remote_state.connectivity-global.outputs.dns_zone_queue_id)[4]
  private_dns_zone_name = data.terraform_remote_state.connectivity-global.outputs.dns_zone_queue_name
  virtual_network_id    = module.hub_vnet.hub_vnet_id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "table" {
  name                  = "link-table-hub-${local.location_short}"
  resource_group_name   = split("/", data.terraform_remote_state.connectivity-global.outputs.dns_zone_table_id)[4]
  private_dns_zone_name = data.terraform_remote_state.connectivity-global.outputs.dns_zone_table_name
  virtual_network_id    = module.hub_vnet.hub_vnet_id
  registration_enabled  = false
  tags                  = local.tags
}
