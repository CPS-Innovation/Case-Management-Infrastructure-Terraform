resource "azurerm_monitor_alert_processing_rule_suppression" "suppress_resolved" {
  name                = "apr-${var.project_acronym}-supress-resolved-${var.environment}"
  resource_group_name = var.rg_name
  enabled             = true
  scopes              = var.suppression_scopes

  condition {
    monitor_condition {
      operator = "Equals"
      values   = ["Resolved"]
    }
  }

  tags = var.tags
}
