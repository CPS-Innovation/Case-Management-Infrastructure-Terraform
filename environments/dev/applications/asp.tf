module "asp_linux" {
<<<<<<< HEAD
  source = "../../../modules/app-service-plan"
=======
  source = "../../../modules/app-service-plan.tf"
>>>>>>> aa3af42 (add app layer)

  environment     = var.environment
  project_acronym = var.project_acronym
  location        = var.location
  tags            = local.tags
  rg_name         = module.rg.rg_name

  os_type = "linux"
  sku     = "B2"
}

module "asp_windows" {
<<<<<<< HEAD
  source = "../../../modules/app-service-plan"
=======
  source = "../../../modules/app-service-plan.tf"
>>>>>>> aa3af42 (add app layer)

  environment     = var.environment
  project_acronym = var.project_acronym
  location        = var.location
  tags            = local.tags
  rg_name         = module.rg.rg_name

  os_type = "windows"
  sku     = "B2" # ???
}
