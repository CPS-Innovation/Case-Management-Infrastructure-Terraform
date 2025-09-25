resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enable_rbac_authorization   = true

  public_network_access_enabled = false

  sku_name = var.kv_sku

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  tags = var.tags
}
