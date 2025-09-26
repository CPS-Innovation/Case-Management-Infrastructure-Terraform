resource "azurerm_service_plan" "asp" {
  #checkov:skip=CKV_AZURE_212:Ensure App Service has a minimum number of instances for failover
  #checkov:skip=CKV_AZURE_225:Ensure the App Service Plan is zone redundant

  count                        = var.create_asp ? 1 : 0
  name                         = "asp-${var.project_acronym}-windows-${var.environment}"
  resource_group_name          = var.rg_name
  location                     = var.location
  os_type                      = "Windows"
  sku_name                     = var.asp_sku
  maximum_elastic_worker_count = var.asp_max_elastic_worker_count
  zone_balancing_enabled       = var.asp_zone_balancing_enabled
  worker_count                 = var.asp_worker_count

  tags = var.tags
}
