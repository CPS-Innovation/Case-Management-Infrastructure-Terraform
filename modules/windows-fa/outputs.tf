output "fa_id" {
  value = azurerm_windows_function_app.fa.id
}

output "fa_slot_id" {
  value = var.create_slot ? azurerm_windows_function_app_slot.fa_slot[0].id : null
}
