# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}
variable "client_id" {
  description = "Enter Client ID for Application in Azure AD"
}
variable "client_secret" {
  description = "Enter Client Secret for Application in Azure AD"
}
variable "tenant_id" {
  description = "Enter Tenant ID / Dirctory ID of your Azure AD. Run Get-AzureSubscription"
}

variable "host_name" {
  description = "VM Name"
  default     = "notSet"
}
variable "host_admin" {
  description = "VM Admin"
  default     = "notSet"
}
variable "host_password" {
  description = "VM Password"
  default     = "notSet"
}

variable "administrator_login" {
  description = "sql server lodin id"
  default     = "notSet"
}

variable "administrator_login_password" {
  description = "sql server lodin password"
  default     = "notSet"
}

variable "app_name" {
  description = "sql server instance name"
  default     = "notSet"
}