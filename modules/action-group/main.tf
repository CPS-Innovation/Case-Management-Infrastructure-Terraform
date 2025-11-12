resource "azurerm_monitor_action_group" "ag" {
  name                = "ag-${var.project_acronym}-${var.function}-${var.environment}"
  resource_group_name = var.rg_name
  short_name          = var.short_name

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.key
      email_address           = email_receiver.value.email
      use_common_alert_schema = email_receiver.value.use_common_alert_schema
    }
  }

  tags = var.tags
}
