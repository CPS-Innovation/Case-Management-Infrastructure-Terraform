resource "azurerm_app_service_custom_hostname_binding" "hostname" {
  hostname            = "www.${var.subdomain_name}.cps.gov.uk"
  app_service_name    = var.app_service_name
  resource_group_name = var.rg_name

  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "hostname" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname.id
}

resource "azurerm_app_service_certificate_binding" "hostname" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname.id
  certificate_id      = azurerm_app_service_managed_certificate.hostname.id
  ssl_state           = "SniEnabled"
}
