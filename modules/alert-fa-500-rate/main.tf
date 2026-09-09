
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alert" {
  name                = "alert-${var.project_acronym}-${var.functional_area}-5xx-rate-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location

  description          = "Alerts when ${var.fa_name} returns a sustained elevated proportion of HTTP 5xx responses."
  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration
  scopes               = [var.app_insights_id]
  severity             = var.severity

  criteria {
    query = <<-QUERY
      requests
      | summarize
          TotalRequests = count(),
          FailedRequests = countif(toint(resultCode) between (500 .. 599))
      | extend FailureRate = FailedRequests * 100.0 / TotalRequests
      | where TotalRequests >= ${var.total_requests_threshold}
      | where FailureRate >= ${var.failure_rate_threshold}
    QUERY

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = var.auto_mitigation_enabled
  workspace_alerts_storage_enabled = false
  enabled                          = true

  action {
    action_groups = var.action_group_ids
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
