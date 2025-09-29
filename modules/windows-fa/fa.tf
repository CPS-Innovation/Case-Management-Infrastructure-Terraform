resource "azurerm_windows_function_app" "fa" {
  name                          = "fa-${var.project_acronym}-${var.functional_area}-${var.environment}"
  resource_group_name           = var.rg_name
  location                      = var.location
  storage_account_name          = var.sa_name
  storage_uses_managed_identity = true
  service_plan_id               = var.asp_id
  virtual_network_subnet_id     = var.vnet_subnet_id
  public_network_access_enabled = false
  builtin_logging_enabled       = false
  https_only                    = true
  client_certificate_mode       = "Required"

  site_config {
    application_insights_connection_string = var.ai_connection_string
    always_on                              = var.always_on
    http2_enabled                          = true
    vnet_route_all_enabled                 = true
    ftps_state                             = "FtpsOnly"
    elastic_instance_minimum               = var.fa_elastic_instance_minimum
    worker_count                           = var.fa_worker_count
    app_scale_limit                        = var.app_scale_limit

    application_stack {
      dotnet_version              = var.dotnet_version
      use_dotnet_isolated_runtime = true
    }

    cors {
      allowed_origins     = var.cors_allowed_origins
      support_credentials = true
    }
  }

  app_settings = var.app_settings

  sticky_settings {
    app_setting_names = keys(var.slot_settings)
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
