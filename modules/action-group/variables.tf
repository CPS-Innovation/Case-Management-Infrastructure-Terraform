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

variable "function" {
  type        = string
  description = "The function / purpose for which the action group is created. E.g 'api-alerts'."
}

variable "short_name" {
  type        = string
  description = "The short name of the action group. Maximum 12 characters."
  validation {
    condition     = length(var.short_name) <= 12
    error_message = "The short name may not exceed 12 characters."
  }
}

variable "email_receivers" {
  type = map(object({
    email                   = string
    use_common_alert_schema = bool
  }))
}
