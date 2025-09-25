resource "azurerm_private_endpoint" "sa" {
  name                = "pe-${azurerm_storage_account.sa.name}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = azurerm_storage_account.sa.name
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sa-dns-zone-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags
}