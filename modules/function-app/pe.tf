resource "azurerm_private_endpoint" "fa" {
  name                = "pe-${azurerm_windows_function_app.fa.name}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = azurerm_windows_function_app.fa.name
    private_connection_resource_id = azurerm_windows_function_app.fa.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "fa-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "fa_slot" {
  count               = var.create_slot ? 1 : 0
  name                = "pe-${azurerm_windows_function_app.fa.name}-${var.slot_name}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${azurerm_windows_function_app.fa.name}-${var.slot_name}"
    private_connection_resource_id = azurerm_windows_function_app.fa.id
    subresource_names              = ["sites-${var.slot_name}"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "fa-slot-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags

  depends_on = [azurerm_windows_function_app_slot.fa_slot]
}
