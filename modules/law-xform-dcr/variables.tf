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

variable "law_name" {
  type        = string
  description = "The name of the Log Analytics Workspace to which this DCR applies."
}

variable "law_id" {
  type        = string
  description = "The resource ID of the Log Analytics Workspace to which this DCR applies."
}

# variable "rg_id" {
#   type        = string
#   description = "The ID of the resource group of the Log Analytics Workspace and DCR."
# }

variable "data_flows" {
  type = map(object({
    tables        = list(string)
    transform_kql = string
  }))
  description = "A map of data flows to be created within the DCR. Each data flow is an object with a list of tables and the KQL query to run against them."
}
