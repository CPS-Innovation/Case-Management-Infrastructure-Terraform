variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the resource."
}

variable "location" {
  type        = string
  description = "The location of the virtual network."
}

variable "tags" {
  type        = map(string)
  description = "A map of tag names to values."
}
