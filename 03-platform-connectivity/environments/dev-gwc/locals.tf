# =============================================================================
# West Europe (weu) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  connectivity_subscription_id = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id

  # ---------------------------------------------------------------------------
  # Configuration
  # ---------------------------------------------------------------------------
  environment    = "dev"
  location       = "germanywestcentral"
  location_short = "gwc"
  location_index = 2 # weu=1, gwc=2, ..., etc.
  common_tags = {
    environment = local.environment
    managed_by  = "opentofu"
    project     = "levendaal"
    layer       = "platform-connectivity"
    location    = local.location
  }

  enterprise_cidr = "10.0.0.0/8"

  # This location /16 block
  location_cidr = cidrsubnet(local.enterprise_cidr, 8, local.location_index) # 10.2.0.0/16
  # Hub network /20 (4,096 IPs)
  hub_cidr = cidrsubnet(local.location_cidr, 4, 0) # 10.2.0.0/20

  # Reserved azure managed subnets
  hub_azure_subnets = {
    GatewaySubnet           = cidrsubnet(local.hub_cidr, 6, 0) # 10.2.0.0/26    (64 IPs) - VPN/ExpressRoute Gateway
    AzureFirewallSubnet     = cidrsubnet(local.hub_cidr, 6, 1) # 10.2.0.64/26   (64 IPs) - Azure Firewall
    AzureBastionSubnet      = cidrsubnet(local.hub_cidr, 6, 2) # 10.2.0.128/26  (64 IPs) - Azure Bastion
    RouteServerSubnet       = cidrsubnet(local.hub_cidr, 6, 3) # 10.2.0.192/26  (64 IPs) - Route Server
    AzureFirewallManagement = cidrsubnet(local.hub_cidr, 6, 4) # 10.2.1.0/26    (64 IPs) - Firewall management
  }

  # Reserved platform managed subnets
  hub_managed_subnets = {
    ApplicationGatewaySubnet                                                    = cidrsubnet(local.hub_cidr, 6, 5)  # 10.2.1.64/26   (64 IPs) - App Gateway
    ApiManagementSubnet                                                         = cidrsubnet(local.hub_cidr, 6, 6)  # 10.2.1.128/26  (64 IPs) - API Management
    "snet-nva-co-${local.environment}-${local.location_short}-01"               = cidrsubnet(local.hub_cidr, 7, 14) # 10.2.1.192/27  (32 IPs) - NVA
    "snet-dns-inbound-co-${local.environment}-${local.location_short}-01"       = cidrsubnet(local.hub_cidr, 7, 15) # 10.2.1.224/27  (32 IPs) - DNS inbound
    "snet-dns-outbound-co-${local.environment}-${local.location_short}-01"      = cidrsubnet(local.hub_cidr, 7, 16) # 10.2.2.0/27    (32 IPs) - DNS outbound
    "snet-management-co-${local.environment}-${local.location_short}-01"        = cidrsubnet(local.hub_cidr, 7, 17) # 10.2.2.32/27   (32 IPs) - Jump boxes
    "snet-private-endpoints-co-${local.environment}-${local.location_short}-01" = cidrsubnet(local.hub_cidr, 6, 9)  # 10.2.2.64/26   (64 IPs) - Private endpoints
    "snet-shared-services-co-${local.environment}-${local.location_short}-01"   = cidrsubnet(local.hub_cidr, 6, 10) # 10.2.2.128/26  (64 IPs) - Shared services
  }
}
