variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group to be imported."
  type        = string
}

/*variable "vnet_id" {
  description = "vnet id form module"  
  type = string
}
*/

variable "vnet_name" {
  description = "vnet name form module"
  type = string
  
}

variable "subnet_id" {
  description = "subnet id name form module"
  type = string
  
}

variable "host_name" {
  description = "Linux host name"
  type = string
}

variable "host_admin" {
  description = "Linux host admin"
  type = string
}

variable "host_password" {
  description = "Linux host password"
  type = string
}