

# DB SUBNET
resource "azurerm_subnet" "dbsub" {
  name                 = "dbsubn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes       = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.sqlserver.name
  subnet_id           = azurerm_subnet.dbsub.id
}

# SQL SERVER
resource "azurerm_sql_server" "sqlserver" {
  name                         = var.app_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
}


