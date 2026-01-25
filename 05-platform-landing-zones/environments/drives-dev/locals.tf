# =============================================================================
# Drives Landing Zone (dev) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  subscription_id              = data.terraform_remote_state.management.outputs.plz_drives_subscription.subscription_id
  connectivity_subscription_id = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id

  # Hub VNet from connectivity layer (for peering)
  hub_vnet_id             = data.terraform_remote_state.connectivity_weu.outputs.hub.id
  hub_vnet_name           = data.terraform_remote_state.connectivity_weu.outputs.hub.name
  hub_resource_group_name = data.terraform_remote_state.connectivity_weu.outputs.hub.resource_group_name
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
  # Subnets within the spoke VNet CIDR (10.1.96.0/20 = 4,096 IPs)
  # Using /24 subnets = 256 IPs each, leaving room for growth
  # ---------------------------------------------------------------------------
  lz_managed_subnets = {
    "snet-app-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 4, 0) # 256 IPs for app services
      service_endpoints = []
    }
    "snet-data-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 4, 1) # 256 IPs for data services
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
    "snet-privateendpoints-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 4, 2) # 256 IPs for private endpoints
      service_endpoints = []
    }
  }

  # Azure reserved subnets: Azure-reserved names (no NSG/route table per Azure requirements)
  azure_reserved_subnets = {
    GatewaySubnet = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 3) # 64 IPs for VPN/ExpressRoute Gateway
      service_endpoints = []
    }
    AzureFirewallSubnet = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 4) # 64 IPs for Azure Firewall
      service_endpoints = []
    }
    AzureBastionSubnet = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 5) # 64 IPs for Azure Bastion
      service_endpoints = []
    }
    RouteServerSubnet = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 6) # 64 IPs for Route Server
      service_endpoints = []
    }
    AzureFirewallManagementSubnet = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 7) # 64 IPs for Firewall Management
      service_endpoints = []
    }
  }

  # Azure delegated subnets: Delegated to Azure services (no NSG/route table per delegation requirements)
  azure_delegated_subnets = {
    "snet-appservice-${local.landing_zone}-${local.environment}-${local.location_short}-01" = {
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 8) # 64 IPs for App Service integration
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
      address_prefix    = cidrsubnet(local.spoke_cidr, 6, 9) # 64 IPs for Container Instances
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
