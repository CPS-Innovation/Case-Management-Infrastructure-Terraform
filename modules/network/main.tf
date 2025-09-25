resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.vnet_rg # This must be the resource group that the virtual network resides in
  virtual_network_name = var.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.service_delegation == true ? [1] : []

    content {
      name = "delegation-${each.key}"

      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  count               = var.create_nsg ? 1 : 0
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.vnet_rg

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                         = security_rule.key
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range != null ? security_rule.value.source_port_range : null
      source_port_ranges           = security_rule.value.source_port_range == null ? security_rule.value.source_port_ranges : null
      destination_port_range       = security_rule.value.destination_port_range != null ? security_rule.value.destination_port_range : null
      destination_port_ranges      = security_rule.value.destination_port_range == null ? security_rule.value.destination_port_ranges : null
      source_address_prefix        = security_rule.value.source_address_prefix != null ? security_rule.value.source_address_prefix : null
      source_address_prefixes      = security_rule.value.source_address_prefix == null ? security_rule.value.source_address_prefixes : null
      destination_address_prefix   = security_rule.value.destination_address_prefix != null ? security_rule.value.destination_address_prefix : null
      destination_address_prefixes = security_rule.value.destination_address_prefix == null ? security_rule.value.destination_address_prefixes : null
    }
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_djb_subnet_assoc" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = var.create_nsg ? azurerm_network_security_group.nsg[0].id : var.nsg_id

  depends_on = [
    azurerm_subnet.subnets,
  ]
}

resource "azurerm_subnet_route_table_association" "djb_rt" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = var.route_table_id

  depends_on = [
    azurerm_subnet.subnets,
    azurerm_network_security_group.nsg
  ]
}
