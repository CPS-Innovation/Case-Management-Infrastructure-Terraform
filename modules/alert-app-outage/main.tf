resource "azurerm_monitor_metric_alert" "alert" {
  name                = "alert-${var.project_acronym}-${var.functional_area}-outage-${var.environment}"
  resource_group_name = var.rg_name
  scopes              = [var.app_id]
  severity            = var.severity
  description         = "No 2xx responses received from ${var.app_name} in 5 minutes. This indicates the service may be down."

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http2xx"
    aggregation      = "Minimum"
    operator         = "LessThan"
    threshold        = 1
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
