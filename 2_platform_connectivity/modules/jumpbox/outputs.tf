# -----------------------------------------------------------------------------
# Jumpbox Module - Outputs
# -----------------------------------------------------------------------------

output "private_ip" {
  description = "Private IP of the jumpbox"
  value       = azurerm_network_interface.this.private_ip_address
}

output "vm_id" {
  description = "ID of the jumpbox VM"
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "Name of the jumpbox VM"
  value       = azurerm_linux_virtual_machine.this.name
}
