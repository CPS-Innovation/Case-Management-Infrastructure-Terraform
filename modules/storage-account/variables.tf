variable "tags" {
  type        = map(string)
  description = "A map of tag names to values."
}

variable "project_acronym" {
  type        = string
  description = "The abbreviated project name."
}

variable "environment" {
  type        = string
  description = "The deployment environment."
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the resource."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
}

variable "functional_area" {
  type        = string
  description = "The functional area / subsystem / workload for which the Storage Account is created. E.g 'backend'."
  default     = ""
}

variable "pe_subnet_id" {
  type        = string
  description = "The id of the subnet within which the Private Endpoint IP is located."
}

variable "private_endpoints" {
  type        = map(string)
  description = "A map of subresource names to their respective private dns zone ids. E.g. { blob = azurerm_private_dns_zone.blob.id }"
}
