# -----------------------------------------------------------------------------
# Jumpbox Module - Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the jumpbox VM"
  type        = string
}

variable "nic_name" {
  description = "Name of the jumpbox NIC"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for jumpbox deployment"
  type        = string
}

variable "vm_size" {
  description = "Size of the jumpbox VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "jmpadmin"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for admin access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
