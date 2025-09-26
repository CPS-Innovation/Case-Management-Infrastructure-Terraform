output "app_id" {
  value = azurerm_linux_web_app.app.id
}

output "app_slot_id" {
  value = var.create_slot ? azurerm_linux_web_app_slot.app_slot[0].id : null
}

output "asp_id" {
  value = var.create_asp ? azurerm_service_plan.asp[0].id : null
}
