# -----------------------------------------------------------------------------
# HA NVA Module - Outputs
# Outputs used by Ansible for dynamic inventory
# -----------------------------------------------------------------------------

output "lb_private_ip" {
  description = "Private IP of the load balancer (use as next hop)"
  value       = var.lb_private_ip
}

output "nva_primary_private_ip" {
  description = "Private IP of the primary NVA"
  value       = azurerm_network_interface.nva_primary.private_ip_address
}

output "nva_secondary_private_ip" {
  description = "Private IP of the secondary NVA"
  value       = azurerm_network_interface.nva_secondary.private_ip_address
}

output "nva_primary_vm_name" {
  description = "Name of the primary NVA VM"
  value       = azurerm_linux_virtual_machine.nva_primary.name
}

output "nva_secondary_vm_name" {
  description = "Name of the secondary NVA VM"
  value       = azurerm_linux_virtual_machine.nva_secondary.name
}

output "nva_primary_vm_id" {
  description = "ID of the primary NVA VM"
  value       = azurerm_linux_virtual_machine.nva_primary.id
}

output "nva_secondary_vm_id" {
  description = "ID of the secondary NVA VM"
  value       = azurerm_linux_virtual_machine.nva_secondary.id
}

output "lb_id" {
  description = "ID of the internal load balancer"
  value       = azurerm_lb.this.id
}
