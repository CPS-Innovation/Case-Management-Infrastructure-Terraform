resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_acronym}${var.functional_area}-${var.environment}"
  location = var.location

  tags = var.tags
}
