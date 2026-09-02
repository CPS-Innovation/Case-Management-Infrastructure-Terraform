locals {
  excluded_exceptions = jsonencode(var.excluded_exceptions)

  exclusion_conditions = length(var.excluded_exceptions) != 0 ? join(" or ", [
    for k in keys(var.excluded_exceptions) :
    "tostring(${k}) in (ExcludedEExceptions.${k})"
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
            ExUser   = coalesce(tostring(user_Id),
                        tostring(user_AuthenticatedId),
                        tostring(customDimensions.User),
                        tostring(customDimensions.user),
                        tostring(customDimensions.UserId))
        | extend Parsed  = parse_json(details)
        | mv-expand Parsed
        | mv-expand Frame = parse_json(tostring(Parsed.parsedStack))
        | extend StackFrame = strcat(
            "  at ", tostring(Frame.method),
            " in ", tostring(Frame.fileName),
            ":", tostring(Frame.line))
        | summarize
            StackSnippet  = strcat_array(make_list(StackFrame, 5), "\r\n"),
            CrashFunction = tostring(make_list(tostring(Frame.method))[0]),
            CrashFile     = tostring(make_list(tostring(Frame.fileName))[0]),
            CrashLine     = tostring(make_list(tostring(Frame.line))[0]),
            ExUser        = any(ExUser)
            by operation_Id, OuterErr, InnerErr,
              problemId, cloud_RoleName;
        CrashDetails
        | join kind=leftouter (requests) on operation_Id
        | project
            Timestamp     = tostring(timestamp),
            CloudRole     = tostring(cloud_RoleName),
            Url           = url,
            ResultCode    = resultCode,
            User          = coalesce(tostring(user_Id),
                              tostring(user_AuthenticatedId),
                              ExUser),
            OuterError    = OuterErr,
            InnerError    = InnerErr,
            CrashedAt     = strcat(CrashFunction, " (", CrashFile, ":", CrashLine, ")"),
            ProblemId     = problemId,
            StackSnippet  = StackSnippet
      KQL
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dynamic "dimension" {
      for_each = ["Timestamp", "CloudRole", "Url", "ResultCode", "User", "OuterError", "InnerError", "CrashedAt", "ProblemId", "StackSnippet"]
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
