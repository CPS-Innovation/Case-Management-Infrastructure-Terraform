resource "azurerm_application_insights" "ai" {
  name                       = "ai-djb-${var.environment}"
  location                   = var.location
  resource_group_name        = var.rg_name
  application_type           = "web"
  workspace_id               = azurerm_log_analytics_workspace.law.id
  internet_ingestion_enabled = false
  internet_query_enabled     = false

  tags = var.tags
}
