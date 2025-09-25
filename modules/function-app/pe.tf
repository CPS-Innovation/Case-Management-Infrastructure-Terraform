resource "azurerm_private_endpoint" "fa" {
  name                = "pe-${azurerm_linux_function_app.fa.name}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = azurerm_linux_function_app.fa.name
    private_connection_resource_id = azurerm_linux_function_app.fa.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "fa-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags
}
