resource "azurerm_log_analytics_workspace" "law" {
  name                       = "log-analytics-djb-${var.environment}"
  location                   = var.location
  resource_group_name        = var.rg_name
  sku                        = "PerGB2018"
  retention_in_days          = 60
  internet_ingestion_enabled = false
  internet_query_enabled     = false

  tags = var.tags
}
