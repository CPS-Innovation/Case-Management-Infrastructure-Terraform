resource "azurerm_private_endpoint" "pe" {
  name                = "pe-${azurerm_linux_web_app.app.name}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = azurerm_linux_web_app.app.name
    private_connection_resource_id = azurerm_linux_web_app.app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "app_slot" {
  count               = var.create_slot ? 1 : 0
  name                = "pe-${azurerm_linux_web_app.app.name}-${var.slot_name}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${azurerm_linux_web_app.app.name}-${var.slot_name}"
    private_connection_resource_id = azurerm_linux_web_app.app.id
    subresource_names              = ["sites-${var.slot_name}"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app-slot-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags

  depends_on = [azurerm_linux_web_app_slot.app_slot[0]]
}
