resource "azurerm_monitor_action_group" "api_alerts" {
  name                = "ag-${var.project_acronym}-api-${var.environment}"
  resource_group_name = module.rg.rg_name
  short_name          = "${var.project_acronym}-api"

  email_receiver {
    name                    = "EmailDevTeam"
    email_address           = var.dev_team_email
    use_common_alert_schema = false
  }
}
