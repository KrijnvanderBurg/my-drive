# -----------------------------------------------------------------------------
# HA NVA Module - Variables
# -----------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for NVA deployment"
  type        = string
}

variable "vm_name_primary" {
  description = "Name of the primary NVA VM"
  type        = string
}

variable "vm_name_secondary" {
  description = "Name of the secondary NVA VM"
  type        = string
}

variable "nic_name_primary" {
  description = "Name of the primary NVA NIC"
  type        = string
}

variable "nic_name_secondary" {
  description = "Name of the secondary NVA NIC"
  type        = string
}

variable "lb_name" {
  description = "Name of the internal load balancer"
  type        = string
}

variable "nva_primary_private_ip" {
  description = "Private IP for primary NVA"
  type        = string
}

variable "nva_secondary_private_ip" {
  description = "Private IP for secondary NVA"
  type        = string
}

variable "lb_private_ip" {
  description = "Private IP for the load balancer frontend"
  type        = string
}

variable "vm_size" {
  description = "Size of the NVA VMs"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Admin username for NVA VMs"
  type        = string
  default     = "nvaadmin"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for admin access"
  type        = string
}

variable "image_publisher" {
  description = "Image publisher for NVA"
  type        = string
  default     = "netgate"
}

variable "image_offer" {
  description = "Image offer for NVA"
  type        = string
  default     = "pfsense-plus-fw-vpn-router"
}

variable "image_sku" {
  description = "Image SKU for NVA"
  type        = string
  default     = "pfsense-plus"
}

variable "image_version" {
  description = "Image version for NVA"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
