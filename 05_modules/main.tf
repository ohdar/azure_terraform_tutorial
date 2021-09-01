
resource "azurerm_resource_group" "rg" {
  name     = "mylinuxresource"
  location = "centralindia"
}

module "vnet" {
  source = "./modules/vnet"
  # source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.rg]
}

module "createvm" {
  source                  = "./modules/vm"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  vnet_name               = module.vnet.vnet_name
 // vnet_id                 = module.vnet.vnet_id
  subnet_id               = module.vnet.vnet_subnets[0]
  host_name               = "mylinux"
  host_admin              = "myadmin"
  host_password           = "Password1234"

  depends_on = [azurerm_resource_group.rg]

}