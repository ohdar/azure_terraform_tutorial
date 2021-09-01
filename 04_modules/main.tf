
module "Module" {
  source         = "./Module"
  resource_group = "Build-RG"
  location       = "centralindia"
  vnet           = "Build-vnet"

}