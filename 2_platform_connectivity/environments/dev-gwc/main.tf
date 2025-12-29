# -----------------------------------------------------------------------------
# Main Configuration - Germany West Central Hub
# Hub VNet, NVA HA, Platform Spokes (Identity + Management)
# -----------------------------------------------------------------------------

# =============================================================================
# HUB RESOURCE GROUP
# =============================================================================

module "hub_rg" {
  source = "../../modules/resource-group"

  name     = local.hub_rg_name
  location = var.location
  tags     = local.common_tags
}

# =============================================================================
# HUB VIRTUAL NETWORK
# =============================================================================

module "hub_vnet" {
  source = "../../modules/virtual-network"

  name                = local.hub_vnet_name
  resource_group_name = module.hub_rg.name
  location            = var.location
  address_space       = var.hub_address_space
  tags                = local.common_tags
}

# =============================================================================
# HUB SUBNETS
# =============================================================================

module "subnet_nva" {
  source = "../../modules/subnet"

  name                 = "snet-hubnva-co-${var.environment}-${var.location_short}-01"
  resource_group_name  = module.hub_rg.name
  virtual_network_name = module.hub_vnet.name
  address_prefixes     = [var.subnet_nva]
}

module "subnet_management" {
  source = "../../modules/subnet"

  name                 = "snet-hubmgmt-co-${var.environment}-${var.location_short}-01"
  resource_group_name  = module.hub_rg.name
  virtual_network_name = module.hub_vnet.name
  address_prefixes     = [var.subnet_management]
}

module "subnet_jumpbox" {
  source = "../../modules/subnet"

  name                 = "snet-hubjmp-co-${var.environment}-${var.location_short}-01"
  resource_group_name  = module.hub_rg.name
  virtual_network_name = module.hub_vnet.name
  address_prefixes     = [var.subnet_jumpbox]
}

# =============================================================================
# NETWORK SECURITY GROUPS
# =============================================================================

module "nsg_nva" {
  source = "../../modules/network-security-group"

  name                = "nsg-hubnva-co-${var.environment}-${var.location_short}-01"
  resource_group_name = module.hub_rg.name
  location            = var.location
  tags                = local.common_tags
}

module "nsg_jumpbox" {
  source = "../../modules/network-security-group"

  name                = "nsg-hubjmp-co-${var.environment}-${var.location_short}-01"
  resource_group_name = module.hub_rg.name
  location            = var.location
  security_rules = {
    allow-ssh-inbound = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  tags = local.common_tags
}

module "nsg_association_nva" {
  source = "../../modules/nsg-association"

  subnet_id                 = module.subnet_nva.id
  network_security_group_id = module.nsg_nva.id
}

module "nsg_association_jumpbox" {
  source = "../../modules/nsg-association"

  subnet_id                 = module.subnet_jumpbox.id
  network_security_group_id = module.nsg_jumpbox.id
}

# =============================================================================

# HA NVA (pfSense)
# =============================================================================

module "nva_ha" {
  source = "../../modules/nva-ha"

  resource_group_name      = module.hub_rg.name
  location                 = var.location
  subnet_id                = module.subnet_nva.id
  vm_name_primary          = "vm-hubnva-co-${var.environment}-${var.location_short}-01"
  vm_name_secondary        = "vm-hubnva-co-${var.environment}-${var.location_short}-02"
  nic_name_primary         = "nic-hubnva-co-${var.environment}-${var.location_short}-01"
  nic_name_secondary       = "nic-hubnva-co-${var.environment}-${var.location_short}-02"
  lb_name                  = "lb-hubnva-co-${var.environment}-${var.location_short}-01"
  nva_primary_private_ip   = var.nva_primary_ip
  nva_secondary_private_ip = var.nva_secondary_ip
  lb_private_ip            = var.nva_lb_ip
  admin_ssh_public_key     = var.admin_ssh_public_key
  tags                     = local.common_tags
}

# =============================================================================
# JUMPBOX
# =============================================================================

module "jumpbox" {
  source = "../../modules/jumpbox"

  name                 = "vm-hubjmp-co-${var.environment}-${var.location_short}-01"
  nic_name             = "nic-hubjmp-co-${var.environment}-${var.location_short}-01"
  resource_group_name  = module.hub_rg.name
  location             = var.location
  subnet_id            = module.subnet_jumpbox.id
  admin_ssh_public_key = var.admin_ssh_public_key
  tags                 = local.common_tags
}

# =============================================================================
# PRIVATE DNS ZONES (Central in Hub)
# =============================================================================

module "dns_zone_blob" {
  source = "../../modules/private-dns-zone"

  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.hub_rg.name
  tags                = local.common_tags
}

module "dns_zone_keyvault" {
  source = "../../modules/private-dns-zone"

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = module.hub_rg.name
  tags                = local.common_tags
}

module "dns_link_blob_hub" {
  source = "../../modules/private-dns-zone-link"

  name                  = "link-hub-blob-${var.location_short}"
  resource_group_name   = module.hub_rg.name
  private_dns_zone_name = module.dns_zone_blob.name
  virtual_network_id    = module.hub_vnet.id
  tags                  = local.common_tags
}

module "dns_link_keyvault_hub" {
  source = "../../modules/private-dns-zone-link"

  name                  = "link-hub-kv-${var.location_short}"
  resource_group_name   = module.hub_rg.name
  private_dns_zone_name = module.dns_zone_keyvault.name
  virtual_network_id    = module.hub_vnet.id
  tags                  = local.common_tags
}

# =============================================================================
# PLATFORM SPOKE: IDENTITY
# =============================================================================

module "identity_rg" {
  source = "../../modules/resource-group"

  name     = "rg-identity-co-${var.environment}-${var.location_short}-01"
  location = var.location
  tags     = local.common_tags
}

module "identity_vnet" {
  source = "../../modules/virtual-network"

  name                = "vnet-identity-co-${var.environment}-${var.location_short}-01"
  resource_group_name = module.identity_rg.name
  location            = var.location
  address_space       = var.identity_spoke_address_space
  tags                = local.common_tags
}

module "identity_subnet" {
  source = "../../modules/subnet"

  name                 = "snet-identity-co-${var.environment}-${var.location_short}-01"
  resource_group_name  = module.identity_rg.name
  virtual_network_name = module.identity_vnet.name
  address_prefixes     = var.identity_spoke_address_space
}

module "identity_route_table" {
  source = "../../modules/route-table"

  name                = "rt-identity-co-${var.environment}-${var.location_short}-01"
  resource_group_name = module.identity_rg.name
  location            = var.location
  routes = {
    to-internet = {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.nva_lb_ip
    }
  }
  tags = local.common_tags
}

module "identity_rt_association" {
  source = "../../modules/route-table-association"

  subnet_id      = module.identity_subnet.id
  route_table_id = module.identity_route_table.id
}

module "hub_to_identity_peering" {
  source = "../../modules/vnet-peering"

  peering_name_source_to_destination = "peer-hubtoidentity-co-${var.environment}-${var.location_short}-01"
  peering_name_destination_to_source = "peer-identitytohub-co-${var.environment}-${var.location_short}-01"
  source_resource_group_name         = module.hub_rg.name
  source_virtual_network_name        = module.hub_vnet.name
  source_virtual_network_id          = module.hub_vnet.id
  destination_resource_group_name    = module.identity_rg.name
  destination_virtual_network_name   = module.identity_vnet.name
  destination_virtual_network_id     = module.identity_vnet.id
  source_allow_gateway_transit       = true
  destination_use_remote_gateways    = false
}

# =============================================================================
# PLATFORM SPOKE: MANAGEMENT
# =============================================================================

module "management_rg" {
  source = "../../modules/resource-group"

  name     = "rg-management-co-${var.environment}-${var.location_short}-01"
  location = var.location
  tags     = local.common_tags
}

module "management_vnet" {
  source = "../../modules/virtual-network"

  name                = "vnet-management-co-${var.environment}-${var.location_short}-01"
  resource_group_name = module.management_rg.name
  location            = var.location
  address_space       = var.management_spoke_address_space
  tags                = local.common_tags
}

module "management_subnet" {
  source = "../../modules/subnet"

  name                 = "snet-management-co-${var.environment}-${var.location_short}-01"
  resource_group_name  = module.management_rg.name
  virtual_network_name = module.management_vnet.name
  address_prefixes     = var.management_spoke_address_space
}

module "management_route_table" {
  source = "../../modules/route-table"

  name                = "rt-management-co-${var.environment}-${var.location_short}-01"
  resource_group_name = module.management_rg.name
  location            = var.location
  routes = {
    to-internet = {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.nva_lb_ip
    }
  }
  tags = local.common_tags
}

module "management_rt_association" {
  source = "../../modules/route-table-association"

  subnet_id      = module.management_subnet.id
  route_table_id = module.management_route_table.id
}

module "hub_to_management_peering" {
  source = "../../modules/vnet-peering"

  peering_name_source_to_destination = "peer-hubtomgmt-co-${var.environment}-${var.location_short}-01"
  peering_name_destination_to_source = "peer-mgmttohub-co-${var.environment}-${var.location_short}-01"
  source_resource_group_name         = module.hub_rg.name
  source_virtual_network_name        = module.hub_vnet.name
  source_virtual_network_id          = module.hub_vnet.id
  destination_resource_group_name    = module.management_rg.name
  destination_virtual_network_name   = module.management_vnet.name
  destination_virtual_network_id     = module.management_vnet.id
  source_allow_gateway_transit       = true
  destination_use_remote_gateways    = false
}

# DNS Links for Platform Spokes
module "dns_link_blob_identity" {
  source = "../../modules/private-dns-zone-link"

  name                  = "link-identity-blob-${var.location_short}"
  resource_group_name   = module.hub_rg.name
  private_dns_zone_name = module.dns_zone_blob.name
  virtual_network_id    = module.identity_vnet.id
  tags                  = local.common_tags
}

module "dns_link_blob_management" {
  source = "../../modules/private-dns-zone-link"

  name                  = "link-mgmt-blob-${var.location_short}"
  resource_group_name   = module.hub_rg.name
  private_dns_zone_name = module.dns_zone_blob.name
  virtual_network_id    = module.management_vnet.id
  tags                  = local.common_tags
}
