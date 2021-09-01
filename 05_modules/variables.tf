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
