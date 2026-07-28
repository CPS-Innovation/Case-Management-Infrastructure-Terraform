resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_acronym}${local.qualifier}-${var.environment}"
  location = var.location

  tags = var.tags
}

locals {
  qualifier = var.functional_area == null ? "" : "-${var.functional_area}"
}
