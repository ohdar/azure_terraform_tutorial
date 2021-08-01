# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# This defines Local Variables used with in main tf
variable "prefix" {
  default = "SinglevmRG"
}

# This Creates Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "centralindia"
}

# This creates Virtual Network for Single VM Machine
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# This creates Subnet for Single VM Machine
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create public IPs -1
resource "azurerm_public_ip" "mypublicip" {
  name                = "myPublicIP"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"

  tags = {
    Owner = "Brajesh"
  }
}

# This creates Network Card for Single VM Machine
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    public_ip_address_id          = azurerm_public_ip.mypublicip.id  
    private_ip_address_allocation = "Dynamic"
  }
}

# This Creates Single VM Virtual Machine with vm_size and storage_image os_disk and os_profile

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.host_name
    admin_username = var.host_admin
    admin_password = var.host_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Owner = "Brajesh"
  }
}

