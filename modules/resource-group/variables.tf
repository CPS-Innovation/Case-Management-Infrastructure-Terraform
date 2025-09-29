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

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
}

variable "functional_area" {
  type        = string
  description = "The functional area / subsystem / workload for which the RG is created. Unless left as the default empty string, it must be prefixed with a hyphen. E.g '-backend'."
  default     = ""
  validation {
    condition     = var.functional_area == "" || startswith(var.functional_area, "-")
    error_message = "The value for var.functional_area must be prefixed with a hyphen (-), unless it is left as the default empty string."
  }
}
