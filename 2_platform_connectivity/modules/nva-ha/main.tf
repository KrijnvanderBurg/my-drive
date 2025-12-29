# -----------------------------------------------------------------------------
# HA NVA Module (pfSense)
# Creates active-passive pfSense VMs behind Azure Load Balancer
# Naming: vm-nva-<archetype>-<env>-<region>-<instance>
# Note: pfSense configuration managed by Ansible
# -----------------------------------------------------------------------------

# Network Interfaces for NVA VMs
resource "azurerm_network_interface" "nva_primary" {
  name                  = var.nic_name_primary
  resource_group_name   = var.resource_group_name
  location              = var.location
  ip_forwarding_enabled = true
  tags                  = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.nva_primary_private_ip
  }
}

resource "azurerm_network_interface" "nva_secondary" {
  name                  = var.nic_name_secondary
  resource_group_name   = var.resource_group_name
  location              = var.location
  ip_forwarding_enabled = true
  tags                  = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.nva_secondary_private_ip
  }
}

# Internal Load Balancer for HA
resource "azurerm_lb" "this" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                          = "nva-frontend"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.lb_private_ip
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  name            = "nva-backend-pool"
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  name            = "nva-health-probe"
  loadbalancer_id = azurerm_lb.this.id
  protocol        = "Tcp"
  port            = 443
}

resource "azurerm_lb_rule" "ha_ports" {
  name                           = "ha-ports-rule"
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "nva-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  probe_id                       = azurerm_lb_probe.this.id
  floating_ip_enabled            = true
}

resource "azurerm_network_interface_backend_address_pool_association" "primary" {
  network_interface_id    = azurerm_network_interface.nva_primary.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
}

resource "azurerm_network_interface_backend_address_pool_association" "secondary" {
  network_interface_id    = azurerm_network_interface.nva_secondary.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
}

# NVA Virtual Machines (pfSense)
resource "azurerm_linux_virtual_machine" "nva_primary" {
  name                            = var.vm_name_primary
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nva_primary.id]
  zone                            = "1"
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

resource "azurerm_linux_virtual_machine" "nva_secondary" {
  name                            = var.vm_name_secondary
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nva_secondary.id]
  zone                            = "2"
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
