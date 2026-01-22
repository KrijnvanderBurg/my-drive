# =============================================================================
# Germany West Central (gwc) - Local Variables
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Remote State Outputs
  # ---------------------------------------------------------------------------
  connectivity_subscription_id = data.terraform_remote_state.management.outputs.pl_connectivity_subscription.subscription_id

  # ---------------------------------------------------------------------------
  # Region Configuration
  # ---------------------------------------------------------------------------
  region       = "gwc"
  region_index = 2 # weu=1, gwc=2, neu=3, etc.
  location     = "germanywestcentral"
  environment  = "dev"

  # ---------------------------------------------------------------------------
  # Common Tags
  # ---------------------------------------------------------------------------
  common_tags = {
    environment = local.environment
    managed_by  = "opentofu"
    project     = "levendaal"
    layer       = "platform-connectivity"
    region      = local.region
  }

  # ---------------------------------------------------------------------------
  # IP Address Space
  # ---------------------------------------------------------------------------
  # Enterprise-wide CIDR allocation using cidrsubnet() for easy calculation.
  #
  # Supernet: 10.0.0.0/8 (16,777,216 IPs)
  #   ├── 10.0.0.0/16     Reserved: on-premises          (65,536 IPs)
  #   ├── 10.1.0.0/16     West Europe (weu)              (65,536 IPs)
  #   ├── 10.2.0.0/16     Germany West Central (gwc)     (65,536 IPs)
  #   ├── 10.3.0.0/16     North Europe (neu)             (65,536 IPs)
  #   ├── ...             Future regions                 (65,536 IPs each)
  #   └── 10.255.0.0/16   Reserved: on-premises          (65,536 IPs)
  #
  # Per-region /16 breakdown (65,536 IPs):
  #   ├── /20 slot 0      Hub network                    (4,096 IPs)
  #   ├── /20 slot 1      Spoke: identity                (4,096 IPs)
  #   ├── /20 slot 2      Spoke: data                    (4,096 IPs)
  #   ├── /20 slot 3      Spoke: app                     (4,096 IPs)
  #   ├── /20 slot 4      Spoke: web                     (4,096 IPs)
  #   ├── /20 slot 5      Spoke: shared                  (4,096 IPs)
  #   └── /20 slots 6-15  Reserved for future            (40,960 IPs)
  # ---------------------------------------------------------------------------

  enterprise_cidr = "10.0.0.0/8"

  # Reserved ranges (do not use in Azure)
  reserved_cidrs = {
    onprem_primary   = cidrsubnet(local.enterprise_cidr, 8, 0)   # 10.0.0.0/16
    onprem_secondary = cidrsubnet(local.enterprise_cidr, 8, 255) # 10.255.0.0/16
  }

  # This region's /16 block
  region_cidr = cidrsubnet(local.enterprise_cidr, 8, local.region_index) # 10.2.0.0/16

  # Hub network /20 (4,096 IPs)
  hub_cidr = cidrsubnet(local.region_cidr, 4, 0) # 10.2.0.0/20

  # ---------------------------------------------------------------------------
  # Hub Subnet Reservations (/20 = 4,096 IPs)
  # ---------------------------------------------------------------------------
  # Hub subnets calculated from hub_cidr. Azure names must be exact.
  # /26 = 64 IPs (59 usable), /27 = 32 IPs (27 usable)
  # ---------------------------------------------------------------------------

  # Azure reserved subnets - no NSG/RT allowed
  hub_azure_subnets = {
    GatewaySubnet            = cidrsubnet(local.hub_cidr, 6, 0) # 10.2.0.0/26    (64 IPs) - VPN/ExpressRoute Gateway
    AzureFirewallSubnet      = cidrsubnet(local.hub_cidr, 6, 1) # 10.2.0.64/26   (64 IPs) - Azure Firewall
    AzureBastionSubnet       = cidrsubnet(local.hub_cidr, 6, 2) # 10.2.0.128/26  (64 IPs) - Azure Bastion
    RouteServerSubnet        = cidrsubnet(local.hub_cidr, 6, 3) # 10.2.0.192/26  (64 IPs) - Route Server
    AzureFirewallManagement  = cidrsubnet(local.hub_cidr, 6, 4) # 10.2.1.0/26    (64 IPs) - Firewall management
    ApplicationGatewaySubnet = cidrsubnet(local.hub_cidr, 6, 5) # 10.2.1.64/26   (64 IPs) - App Gateway
    ApiManagementSubnet      = cidrsubnet(local.hub_cidr, 6, 6) # 10.2.1.128/26  (64 IPs) - API Management
  }

  # Platform managed subnets - get NSG and route table
  hub_managed_subnets = {
    "snet-nva-co-${local.environment}-${local.region}-01"             = cidrsubnet(local.hub_cidr, 7, 14) # 10.2.1.192/27  (32 IPs) - NVA
    "snet-dns-inbound-co-${local.environment}-${local.region}-01"     = cidrsubnet(local.hub_cidr, 7, 15) # 10.2.1.224/27  (32 IPs) - DNS inbound
    "snet-dns-outbound-co-${local.environment}-${local.region}-01"    = cidrsubnet(local.hub_cidr, 7, 16) # 10.2.2.0/27    (32 IPs) - DNS outbound
    "snet-management-co-${local.environment}-${local.region}-01"      = cidrsubnet(local.hub_cidr, 7, 17) # 10.2.2.32/27   (32 IPs) - Jump boxes
    "snet-peps-co-${local.environment}-${local.region}-01"            = cidrsubnet(local.hub_cidr, 6, 9)  # 10.2.2.64/26   (64 IPs) - Private endpoints
    "snet-shared-services-co-${local.environment}-${local.region}-01" = cidrsubnet(local.hub_cidr, 6, 10) # 10.2.2.128/26  (64 IPs) - Shared services
  }

  # ---------------------------------------------------------------------------
  # Spoke VNet Allocations (each /20 = 4,096 IPs)
  # ---------------------------------------------------------------------------
  # Workload teams create their own subnets within these ranges.
  # ---------------------------------------------------------------------------

  spoke_cidrs = {
    # identity = cidrsubnet(local.region_cidr, 4, 1) # 10.2.16.0/20  (4,096 IPs)
    # data     = cidrsubnet(local.region_cidr, 4, 2) # 10.2.32.0/20  (4,096 IPs)
    # app      = cidrsubnet(local.region_cidr, 4, 3) # 10.2.48.0/20  (4,096 IPs)
    # web      = cidrsubnet(local.region_cidr, 4, 4) # 10.2.64.0/20  (4,096 IPs)
    # shared   = cidrsubnet(local.region_cidr, 4, 5) # 10.2.80.0/20  (4,096 IPs)
  }

}
