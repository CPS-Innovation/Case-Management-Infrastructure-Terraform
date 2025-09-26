resource "azurerm_service_plan" "asp" {
  count                        = var.create_asp ? 1 : 0
  name                         = "asp-${var.project_acronym}-linux-${var.environment}"
  resource_group_name          = var.rg_name
  location                     = var.location
  os_type                      = "Linux"
  sku_name                     = var.asp_sku
  maximum_elastic_worker_count = var.asp_max_elastic_worker_count
  zone_balancing_enabled       = var.asp_zone_balancing_enabled
  worker_count                 = var.asp_worker_count

  tags = var.tags
}
