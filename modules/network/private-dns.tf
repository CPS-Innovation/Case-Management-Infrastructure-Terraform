resource "azurerm_virtual_network_dns_servers" "dns" {
  count              = var.connect_vnet_to_custom_dns_servers ? 1 : 0
  virtual_network_id = var.vnet_id
  dns_servers        = ["10.8.0.6", "10.8.0.7"]
}

resource "azurerm_private_dns_zone" "dns" {
  for_each            = var.private_dns_zones
  name                = each.value
  resource_group_name = var.vnet_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  for_each = var.private_dns_zones

  name                  = "dnszonelink-${each.key}"
  resource_group_name   = var.vnet_rg
  private_dns_zone_name = each.value
  virtual_network_id    = var.vnet_id

  depends_on = [azurerm_private_dns_zone.dns]
}
