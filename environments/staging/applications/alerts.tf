module "alert_api_5xx" {
  source = "../../../modules/fa-5xx-alert"

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
