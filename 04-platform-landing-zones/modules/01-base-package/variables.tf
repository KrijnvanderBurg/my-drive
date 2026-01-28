# =============================================================================
# Naming Variables
# =============================================================================

variable "landing_zone" {
  description = "Landing zone identifier (e.g., 'drives')"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., 'dev', 'prod')"
  type        = string
}

variable "location_short" {
  description = "Short location code (e.g., 'weu', 'gwc')"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

# =============================================================================
# Optional Overrides
# =============================================================================

variable "log_analytics_retention_in_days" {
  description = "Data retention in days for Log Analytics (7-30 recommended for cost optimization)"
  type        = number
  default     = 30
  validation {
    condition     = var.log_analytics_retention_in_days >= 7 && var.log_analytics_retention_in_days <= 730
    error_message = "Retention must be between 7 and 730 days"
  }
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily ingestion quota in GB for cost control (-1 for unlimited)"
  type        = number
  default     = 5 # Adjust based on your environment size
}

variable "enable_basic_logs" {
  description = "Enable Basic Logs tier for high-volume tables (50% cost reduction)"
  type        = bool
  default     = true
}

variable "log_export_table_names" {
  description = "Log Analytics tables to export to storage (selective for cost optimization)"
  type        = list(string)
  default = [
    "AzureActivity",
    "AzureDiagnostics",
  ]
}

variable "alert_action_group_id" {
  description = "Action group ID for Log Analytics alerts (optional)"
  type        = string
  default     = null
}

# =============================================================================
# Hub Peering Variables
# =============================================================================

variable "hub_vnet_id" {
  description = "Hub VNet ID for peering"
  type        = string
}

variable "hub_vnet_name" {
  description = "Hub VNet name for peering reference"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Name of the hub resource group for peering"
  type        = string
}

variable "location" {
  description = "Azure location_short for resources"
  type        = string
}

variable "address_space" {
  description = "Address space for the spoke VNet (e.g., ['10.1.16.0/20'])"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# =============================================================================
# Subnet Configuration
# =============================================================================

variable "lz_managed_subnets" {
  description = "Landing zone managed subnets with NSG and route table enforcement (zero-trust by default)"
  type = map(object({
    address_prefix    = string
    service_endpoints = list(string)
  }))
  default = {}
}

variable "azure_reserved_subnets" {
  description = "Azure reserved subnets (GatewaySubnet, AzureFirewallSubnet, etc. - no NSG/route table)"
  type = map(object({
    address_prefix    = string
    service_endpoints = list(string)
  }))
  default = {}
}

variable "azure_delegated_subnets" {
  description = "Azure delegated subnets for services (App Service, Container Instances, etc. - no NSG/route table)"
  type = map(object({
    address_prefix    = string
    service_endpoints = list(string)
    delegation = object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })
  }))
  default = {}
}
