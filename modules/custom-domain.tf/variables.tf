variable "rg_name" {
  type        = string
  description = "The name of the resource group containing the bound app service."
}

variable "subdomain_name" {
  type        = string
  description = "The name of the service subdomain under cps.gov.uk."
}

variable "app_service_name" {
  type        = string
  description = "The name of the bound app service resource."
}
