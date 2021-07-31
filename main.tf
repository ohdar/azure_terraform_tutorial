# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Create resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "myResourceGroup"
  location = "centralindia"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ----------------------------------------------------------------------------
# Create public IPs -1
resource "azurerm_public_ip" "myterraformpublicip1" {
  name                = "myPublicIP1"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create public IPs -2
resource "azurerm_public_ip" "myterraformpublicip2" {
  name                = "myPublicIP2"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create public IPs -3
resource "azurerm_public_ip" "myterraformpublicip3" {
  name                = "myPublicIP3"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create public IPs -4
resource "azurerm_public_ip" "myterraformpublicip4" {
  name                = "myPublicIP4"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}


# ----------------------------------------------------------------------------

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# ----------------------------------------------------------------------------
# Create network interface 1
resource "azurerm_network_interface" "myterraformnic1" {
  name                = "myNIC1"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip1.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#Connect the security group to network interface 1
resource "azurerm_network_interface_security_group_association" "example1" {
  network_interface_id      = azurerm_network_interface.myterraformnic1.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create network interface 2
resource "azurerm_network_interface" "myterraformnic2" {
  name                = "myNIC2"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip2.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#Connect the security group to network interface 2
resource "azurerm_network_interface_security_group_association" "example2" {
  network_interface_id      = azurerm_network_interface.myterraformnic2.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create network interface 3
resource "azurerm_network_interface" "myterraformnic3" {
  name                = "myNIC3"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration3"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip3.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#Connect the security group to network interface 3
resource "azurerm_network_interface_security_group_association" "example3" {
  network_interface_id      = azurerm_network_interface.myterraformnic3.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create network interface 4
resource "azurerm_network_interface" "myterraformnic4" {
  name                = "myNIC4"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip4.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#Connect the security group to network interface 1
resource "azurerm_network_interface_security_group_association" "example4" {
  network_interface_id      = azurerm_network_interface.myterraformnic4.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# ----------------------------------------------------------------------------

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    #generate a new Id only when a new resource group is defined
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = "centralindia"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create virtual machine 1
resource "azurerm_linux_virtual_machine" "myterraformvm1" {
  name                  = "myVM1"
  location              = "centralindia"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic1.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm1"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234"
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Create virtual machine 2
resource "azurerm_linux_virtual_machine" "myterraformvm2" {
  name                  = "myVM2"
  location              = "centralindia"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic2.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm2"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234"
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Create virtual machine 3
resource "azurerm_linux_virtual_machine" "myterraformvm3" {
  name                  = "myVM3"
  location              = "centralindia"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic3.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk3"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm3"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234"
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Create virtual machine 4
resource "azurerm_linux_virtual_machine" "myterraformvm4" {
  name                  = "myVM4"
  location              = "centralindia"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic4.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk4"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm4"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234"
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
}

