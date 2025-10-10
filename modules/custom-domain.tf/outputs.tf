output "hostname" {
  value = azurerm_app_service_custom_hostname_binding.hostname
}

output "certificate_id" {
  value = azurerm_app_service_managed_certificate.hostname.id
}
