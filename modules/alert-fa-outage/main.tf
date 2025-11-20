resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alert" {
  name                = "alert-${var.project_acronym}-${var.functional_area}-outage-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location

  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration
  scopes               = [var.app_insights_id]
  severity             = var.severity

  criteria {
    query                   = <<-QUERY
      requests
      | where name == ${var.health_check_request_method}
      | where timestamp > ago(3m)
      | where cloud_RoleName has ${var.fa_name}
      | summarize latestSuccessStatus = arg_max(timestamp, success) by cloud_RoleInstance
      | summarize
          rows = count(),
          healthyInstances = make_set_if(cloud_RoleInstance, success == true),
          unhealthyInstances = make_set_if(cloud_RoleInstance, success == false)
      | extend
          healthyInstanceCount = array_length(healthyInstances),
          unhealthyInstanceCount = array_length(unhealthyInstances)
      | extend serviceDown = iif(healthyInstanceCount == 0 or rows == 0, 1, 0)
      QUERY
    metric_measure_column   = "serviceDown"
    time_aggregation_method = "Maximum"
    operator                = "Equal"
    threshold               = 1

    dynamic "dimension" {
      for_each = ["healthyInstanceCount", "unhealthyInstanceCount"]
      content {
        name     = dimension.value
        operator = "Include"
        values   = ["*"]
      }
    }

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = var.auto_mitigation_enabled
  workspace_alerts_storage_enabled = false
  description                      = "The heartbeat check for ${var.fa_name} has failed, indicating the service may be down."
  enabled                          = true

  action {
    action_groups = var.action_group_ids
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
