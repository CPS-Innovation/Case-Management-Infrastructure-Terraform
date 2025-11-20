module "alert_api_5xx" {
  source = "../../../modules/alert-fa-5xx"

  environment     = var.environment
  project_acronym = var.project_acronym
  location        = var.location
  tags            = local.tags
  rg_name         = module.rg.rg_name

  functional_area  = "api"
  app_insights_id  = module.ai.ai_id
  action_group_ids = [module.ag_api_alerts.id]
  fa_name          = module.fa_main.fa_name
}

module "alert_api_outage" {
  source = "../../../modules/alert-fa-outage"

  environment     = var.environment
  project_acronym = var.project_acronym
  location        = var.location
  tags            = local.tags
  rg_name         = module.rg.rg_name

  functional_area             = "api"
  app_insights_id             = module.ai.ai_id
  action_group_ids            = [module.ag_api_alerts.id]
  fa_name                     = module.fa_main.fa_name
  health_check_request_method = "Status"
}
