resource "azurerm_linux_web_app" "app" {
  name                          = "${var.project_acronym}-app-${var.functional_area}-${var.environment}"
  resource_group_name           = var.rg_name
  location                      = var.location
  service_plan_id               = var.create_asp ? azurerm_service_plan.asp[0].id : var.asp_id
  virtual_network_subnet_id     = var.vnet_subnet_id
  public_network_access_enabled = false
  https_only                    = true

  site_config {
    app_command_line        = var.app_command_line
    always_on               = var.always_on
    http2_enabled           = true
    vnet_route_all_enabled  = true
    ftps_state              = "FtpsOnly"
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"
    managed_pipeline_mode   = "Integrated"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge({
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.ai_connection_string
  }, var.app_settings)

  sticky_settings {
    app_setting_names = keys(var.slot_settings)
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = false

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
