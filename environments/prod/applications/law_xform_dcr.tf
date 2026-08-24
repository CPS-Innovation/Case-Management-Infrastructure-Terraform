module "law_xform_dcr" {
  source = "../../../modules/law-xform-dcr"

  environment     = var.environment
  project_acronym = var.project_acronym
  location        = var.location
  tags            = local.tags
  rg_name         = module.rg.rg_name
  rg_id           = module.rg.rg_id

  law_name = "log-analytics-${var.project_acronym}-${var.environment}"

  data_flows = {
    requests = {
      tables        = ["Microsoft-Table-AppRequests"]
      transform_kql = <<-KQL
        source
        | where Name != "Status"
      KQL
    }
    traces = {
      tables        = ["Microsoft-Table-AppTraces"]
      transform_kql = <<-KQL
        source
        | where Properties["Category"] != "Function.Status"
      KQL
    }
  }
}
