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

variable "functional_area" {
  type        = string
  description = "The functional area / subsystem / workload of the function app monitored by the alert rule."
}

variable "app_id" {
  type        = string
  description = "The resource id of the app service resource monitored by the alert rule."
}

variable "app_name" {
  type        = string
  description = "The name of the app service resource monitored by the alert rule."
}

variable "severity" {
  type        = number
  description = "The severity level to assign to the alert. Should be an integer between 0 and 4. Value of 0 is severest."
  default     = 0
}

variable "action_group_id" {
  type        = string
  description = "List of one or more Action Group resource IDs to invoke when the alert fires."
}
