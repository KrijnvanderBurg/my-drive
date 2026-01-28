# =============================================================================
# Drives Landing Zone (dev) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  tenant_id                       = data.terraform_remote_state.management.outputs.tenant_id
  subscription_id                 = data.terraform_remote_state.management.outputs.plz_drives_subscription.subscription_id
  subscription_scope              = data.terraform_remote_state.management.outputs.plz_drives_subscription.id
  connectivity_subscription_id    = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id
  connectivity_subscription_scope = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.id

  # Hub VNet from connectivity layer (for peering)
  hub_vnet_id             = data.terraform_remote_state.connectivity_weu.outputs.hub.id
  hub_vnet_name           = data.terraform_remote_state.connectivity_weu.outputs.hub.name
  hub_resource_group_name = data.terraform_remote_state.connectivity_weu.outputs.hub.resource_group_name
  hub_subnets             = data.terraform_remote_state.connectivity_weu.outputs.hub.subnets
  spoke_cidr              = data.terraform_remote_state.connectivity_weu.outputs.spokes.plz_drives.cidr

  # ---------------------------------------------------------------------------
  # location_short Configuration (easily changeable)
  # ---------------------------------------------------------------------------
  location       = "westeurope"
  location_short = "weu"
  environment    = "dev"
  landing_zone   = "drives"
  common_tags = {
    environment    = local.environment
    managed_by     = "opentofu"
    project        = "levendaal"
    layer          = "platform-landing-zone"
    landing_zone   = local.landing_zone
    location_short = local.location_short
  }

  # ---------------------------------------------------------------------------
  # Subnet Configuration
  # ---------------------------------------------------------------------------
  # Landing zone managed subnets: Include NSG (zero-trust) and route table
  # Subnets within the spoke VNet CIDR (10.1.16.0/20 = 4,096 IPs)
  # Using /24 subnets = 256 IPs each, leaving room for growth
  # All subnets use consistent /24 subdivision (newbits=4) to avoid overlaps
  # ---------------------------------------------------------------------------
  lz_managed_subnets = {
    "snet-app-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 4, 0) # 10.1.16.0/24 - 256 IPs for app services
      service_endpoints = []
    }
    "snet-data-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 4, 1) # 10.1.17.0/24 - 256 IPs for data services
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
    "snet-privateendpoints-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 4, 2) # 10.1.18.0/24 - 256 IPs for private endpoints
      service_endpoints = []
    }
  }

  # Azure reserved subnets: Azure-reserved names (no NSG/route table per Azure requirements)
  # Using /26 subnets (64 IPs) carved from the 4th /24 block
  azure_reserved_subnets = {
    GatewaySubnet = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 3), 2, 0) # 10.1.19.0/26 - VPN/ExpressRoute Gateway
      service_endpoints = []
    }
    AzureFirewallSubnet = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 3), 2, 1) # 10.1.19.64/26 - Azure Firewall
      service_endpoints = []
    }
    AzureBastionSubnet = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 3), 2, 2) # 10.1.19.128/26 - Azure Bastion
      service_endpoints = []
    }
    RouteServerSubnet = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 3), 2, 3) # 10.1.19.192/26 - Route Server
      service_endpoints = []
    }
    AzureFirewallManagementSubnet = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 4), 2, 0) # 10.1.20.0/26 - Firewall Management
      service_endpoints = []
    }
  }

  # Azure delegated subnets: Delegated to Azure services (no NSG/route table per delegation requirements)
  # Using /26 subnets carved from the 5th /24 block
  azure_delegated_subnets = {
    "snet-appservice-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 4), 2, 1) # 10.1.20.64/26 - App Service integration
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      delegation = {
        name = "appservice-delegation"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
    "snet-containerinstances-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(cidrsubnet(local.spoke_cidr, 4, 4), 2, 2) # 10.1.20.128/26 - Container Instances
      service_endpoints = []
      delegation = {
        name = "containerinstances-delegation"
        service_delegation = {
          name = "Microsoft.ContainerInstance/containerGroups"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/action"
          ]
        }
      }
    }
  }
}
