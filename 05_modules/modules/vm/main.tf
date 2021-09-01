data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name
}

# Create public IPs -1
resource "azurerm_public_ip" "mypublicip" {
  name                = "myPublicIP"
  location            = var.resource_group_location
  resource_group_name = data.azurerm_resource_group.vnet.name
  allocation_method   = "Dynamic"

  tags = {
    Owner = "Brajesh"
  }
}

resource "azurerm_network_interface" "vm_interface" {
  name = "vm_nic"
  location = var.resource_group_location
  resource_group_name = data.azurerm_resource_group.vnet.name

  ip_configuration {
    name                          = var.vnet_name
    subnet_id                     = var.subnet_id
    public_ip_address_id          = azurerm_public_ip.mypublicip.id  
    private_ip_address_allocation = "Dynamic"
  }
  
}



resource "azurerm_linux_virtual_machine" "linuxm" {
  name = "ublinux"
  resource_group_name = data.azurerm_resource_group.vnet.name
  location = var.resource_group_location
  size = "Standard_B1s"
  computer_name  = var.host_name
  admin_username = var.host_admin
  admin_password = var.host_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.vm_interface.id]
  
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }


  
}

