resource "azurerm_monitor_data_collection_rule" "law_xform_dcr" {
  name                = "dcr-${var.project_acronym}-law-xform-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  kind                = "WorkspaceTransforms"

  destinations {
    log_analytics {
      # workspace_resource_id = "${var.rg_id}/providers/Microsoft.OperationalInsights/workspaces/${var.law_name}"
      workspace_resource_id = var.law_id
      name                  = var.law_name
    }
  }

  dynamic "data_flow" {
    for_each = var.data_flows
    content {
      streams       = data_flow.value.tables
      destinations  = [var.law_name]
      transform_kql = data_flow.value.transform_kql
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_data_collection_rule_association" "example1" {
  name                    = "law-dcr-association-${var.project_acronym}-${var.environment}"
  target_resource_id      = var.law_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.law_xform_dcr.id
  description             = "example"
}
