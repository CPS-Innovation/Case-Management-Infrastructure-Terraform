resource "azurerm_role_assignment" "fa" {
  for_each = tomap({
    for item in local.role_assignments_list : "${item.key}.${item.role_definition}" => item
  })
  scope                = each.value.scope
  role_definition_name = each.value.role_definition
  principal_id         = azurerm_windows_function_app.fa.identity[0].principal_id
}

resource "azurerm_role_assignment" "fa_slot" {
  for_each = var.create_slot ? tomap({
    for item in local.role_assignments_list : "${item.key}.${item.role_definition}" => item
  }) : {}
  scope                = each.value.scope
  role_definition_name = each.value.role_definition
  principal_id         = azurerm_windows_function_app_slot.fa_slot[0].identity[0].principal_id
}

locals {
  role_assignments = {
    sa_roles = {
      scope            = var.sa_id
      role_definitions = var.sa_iam_roles
    }
    kv_roles = {
      scope            = var.kv_id
      role_definitions = ["Key Vault Secrets User"]
    }
  }

  role_assignments_list = flatten([
    for key, value in local.role_assignments : [
      for role_definition in value.role_definitions : {
        key             = key
        scope           = value.scope
        role_definition = role_definition
      }
    ]
  ])
}
