resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.project_acronym}-${var.environment}"
  location                    = var.location
  resource_group_name         = var.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  rbac_authorization_enabled  = true

  public_network_access_enabled = false

  sku_name = lower(var.kv_sku)

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  tags = var.tags
}
