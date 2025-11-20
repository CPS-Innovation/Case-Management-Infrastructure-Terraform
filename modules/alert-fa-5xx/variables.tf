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
  description = "The functional area / subsystem / workload of the function app monitored by the alert rule."
}

variable "evaluation_frequency" {
  type        = string
  description = "How often the scheduled query rule is evaluated, represented in ISO 8601 duration format."
  default     = "PT5M"
  validation {
    condition     = contains(["PT1M", "PT5M", "PT10M"], var.evaluation_frequency)
    error_message = "Evaluation frequency must be one of: PT1M, PT5M or PT10M."
  }
}

variable "window_duration" {
  type        = string
  description = "Specifies the period of time in ISO 8601 duration format on which the Scheduled Query Rule will be executed (bin size). Must be >= than evaluation_frequency"
  default     = "PT5M"
  validation {
    condition     = contains(["PT1M", "PT5M", "PT10M"], var.window_duration)
    error_message = "Window duration must be one of: PT1M, PT5M or PT10M."
  }
}

variable "app_insights_id" {
  type        = string
  description = "The resource id of the Application Insights instance monitoring the function app."
}

variable "severity" {
  type        = number
  description = "The severity level to assign to the alert. Should be an integer between 0 and 4. Value of 0 is severest."
  default     = 2
}

variable "auto_mitigation_enabled" {
  type        = bool
  description = "pecifies the flag that indicates whether the alert should be automatically resolved or not."
  default     = false
}

variable "action_group_ids" {
  type        = list(string)
  description = "List of one or more Action Group resource IDs to invoke when the alert fires."
}

variable "fa_name" {
  type        = string
  description = "The name of the function app resource the alert rule is monitoring. Used for the alert's description."
}
