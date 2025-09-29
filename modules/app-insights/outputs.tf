output "ai_connection_string" {
  value = azurerm_application_insights.ai.connection_string
}

output "law_id" {
  value = azurerm_log_analytics_workspace.law.id
}
