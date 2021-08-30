/*
Create two web apps connected securely with Private Endpoint and VNet integration
This article illustrates an example use of Private Endpoint and regional VNet integration to connect two web apps (frontend and backend) securely following these steps:

* Deploy a VNet
* Create the first subnet for the integration
* Create the second subnet for the private endpoint, you have to set a specific parameter to disable network policies
* Deploy one App Service plan of type PremiumV2 or PremiumV3, required for Private Endpoint feature
* Create the frontend web app with specific app settings to consume the private DNS zone, more details
* Connect the frontend web app to the integration subnet
* Create the backend web app
* Create the DNS private zone with the name of the private link zone for web app privatelink.azurewebsites.net
* Link this zone to the VNet
* Create the private endpoint for the backend web app in the endpoint subnet, and register DNS names (website and SCM) in the previously created DNS private zone

The complete terraform file
To use this file you must change the name property for frontwebapp and backwebapp resources (webapp name must be unique DNS name worldwide).

*/

#-------provider block-------------
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
#----- provider block end -----------------

#----- creation of resource group [rg]-------------
resource "azurerm_resource_group" "rg" {
  name     = "appservice-rg"
  location = "centralindia"
}


#----- creation of virtual network [vnet] -----

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}


#----- creation of subnet [integrationsubnet]---------------

resource "azurerm_subnet" "integrationsubnet" {
  name                 = "integrationsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

#---------- creation of endpoint subnet [endpointsubnet]--------------------

resource "azurerm_subnet" "endpointsubnet" {
  name                                           = "endpointsubnet"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = ["10.0.2.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

# ------ creation of app service plan [appserviceplan] ---------

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Premiumv2"
    size = "P1v2"
  }

}

# ----- creation of website forontend [frontwebapp] ------------

resource "azurerm_app_service" "frontwebapp" {
  name                = "frontwebapp20200810"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  app_settings = {
    "WEBSITE_DNS_SERVER" : "168.63.129.16"
    "WEBSITE_VNET_ROUTE_ALL" : "1"
  }

}

#------ creation of app service connection [vnetintegrationconnection]-------

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id = azurerm_app_service.frontwebapp.id
  subnet_id      = azurerm_subnet.integrationsubnet.id
}

#------- creation of BACKWEBAPP ----------------

resource "azurerm_app_service" "backwebapp" {
  name                = "backwebapp20200810"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}

#------- creation of private dns zone [dnsprivatezone]--------------------

resource "azurerm_private_dns_zone" "dnsprivatezone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# ------ creation of dnszone link [dnszonelink]-----------------

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  name                  = "dnszonelink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# ------ creation of private end point [privateendpoint]-----------

resource "azurerm_private_endpoint" "privateendpoint" {
  name                = "dnszonelink"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpointsubnet.id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
  }

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_app_service.backwebapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

}

