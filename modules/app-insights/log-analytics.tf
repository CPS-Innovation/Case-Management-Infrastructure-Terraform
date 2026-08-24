resource "azurerm_log_analytics_workspace" "law" {
  name                         = "log-analytics-${var.project_acronym}-${var.environment}"
  location                     = var.location
  resource_group_name          = var.rg_name
  sku                          = "PerGB2018"
  retention_in_days            = var.log_retention_in_days
  internet_ingestion_enabled   = false
  internet_query_enabled       = false
  local_authentication_enabled = false
  data_collection_rule_id      = var.dcr_id

  tags = var.tags
}
