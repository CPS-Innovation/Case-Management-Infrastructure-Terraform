output "ai_connection_string" {
  value = azurerm_application_insights.ai.connection_string
}

output "ai_id" {
  value = azurerm_application_insights.ai.id
}

output "law_id" {
  value = azurerm_log_analytics_workspace.law.id
}
