resource "azurerm_role_assignment" "ai" {
  scope                = var.app_insights_id
  role_definition_name = "Reader"
  principal_id         = azurerm_monitor_scheduled_query_rules_alert_v2.alert.identity[0].principal_id
}
