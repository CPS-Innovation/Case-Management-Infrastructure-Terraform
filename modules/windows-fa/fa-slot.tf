resource "azurerm_windows_function_app_slot" "fa_slot" {
  count                = var.create_slot ? 1 : 0
  name                 = var.slot_name
  function_app_id      = azurerm_windows_function_app.fa.id
  storage_account_name = var.sa_name

  storage_uses_managed_identity = true
  public_network_access_enabled = false
  virtual_network_subnet_id     = var.vnet_subnet_id
  builtin_logging_enabled       = false
  https_only                    = true

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = var.slot_settings

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      site_config
    ]
  }
}
