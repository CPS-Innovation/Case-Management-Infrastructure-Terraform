locals {
  excluded_exceptions = jsonencode(var.excluded_exceptions)

  exclusion_conditions = length(var.excluded_exceptions) != 0 ? join(" or ", [
    for k in keys(var.excluded_exceptions) :
    "tostring(${k}) in (ExcludedExceptions.${k})"
  ]) : "false"
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alert" {
  name                = "alert-${var.project_acronym}-${var.functional_area}-exceptions-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location

  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration
  scopes               = [var.app_insights_id]
  severity             = var.severity

  criteria {
    query                   = <<-KQL
      let ExcludedExceptions = dynamic(${local.excluded_exceptions});
      let CrashDetails = exceptions
        | where not(${local.exclusion_conditions})
        | where severityLevel >= 3
        | extend
            OuterErr = strcat(outerType, ": ", outerMessage),
            InnerErr = strcat(innermostType, ": ", innermostMessage),
            ExUser = coalesce(
                tostring(user_Id),
                tostring(user_AuthenticatedId),
                tostring(customDimensions.User),
                tostring(customDimensions.user),
                tostring(customDimensions.UserId)
            )
        | mv-expand Parsed = parse_json(details)
        | mv-expand Frame = parse_json(tostring(Parsed.parsedStack))
        | extend StackFrame = strcat(
            "  at ", tostring(Frame.method),
            " in ", tostring(Frame.fileName),
            ":", tostring(Frame.line)
        )
        | summarize
            StackSnippet = strcat_array(make_list(StackFrame, 5), "\r\n"),
            ExUser = any(ExUser)
            by operation_Id, OuterErr, InnerErr, problemId, cloud_RoleName;
        CrashDetails
        | join kind=leftouter (requests) on operation_Id
        | extend
            User = coalesce(
                tostring(user_Id),
                tostring(user_AuthenticatedId),
                ExUser
            )
        | summarize
            Occurrences = count(),
            StackSnippet = any(StackSnippet),
            Users = tostring(make_set(User, 5)),
            Urls = tostring(make_set(url, 5)),
            ResultCodes = tostring(make_set(resultCode, 5)),
            Timestamps = tostring(bag_pack(
             "FirstSeen", min(timestamp),
             "LastSeen", max(timestamp)
            ))
        by
            CloudRole = cloud_RoleName,
            ProblemId = problemId,
            OuterError = OuterErr,
            InnerError = InnerErr
      KQL
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dynamic "dimension" {
      for_each = ["Occurrences", "Timestamps", "CloudRole", "Urls", "ResultCodes", "Users", "OuterError", "InnerError", "ProblemId", "StackSnippet"]
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
  description                      = "Notify stakeholders of exceptions in ${var.fa_name}."
  enabled                          = true

  action {
    action_groups = var.action_group_ids
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
