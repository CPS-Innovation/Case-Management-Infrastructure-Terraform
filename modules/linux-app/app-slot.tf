resource "azurerm_linux_web_app_slot" "app_slot" {
  count                         = var.create_slot ? 1 : 0
  name                          = var.slot_name
  app_service_id                = azurerm_linux_web_app.app.id
  virtual_network_subnet_id     = var.vnet_subnet_id
  public_network_access_enabled = false
  https_only                    = true

  site_config {
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = var.slot_settings

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
      tags,
      site_config
    ]
  }
}
