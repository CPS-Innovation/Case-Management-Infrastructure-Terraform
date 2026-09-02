module "alert_processing_rule" {
  source = "../../../modules/alert-processing"

  environment     = var.environment
  project_acronym = var.project_acronym
  tags            = local.tags
  rg_name         = module.rg.rg_name

  suppression_scopes = [
    module.rg.rg_id
  ]
}
