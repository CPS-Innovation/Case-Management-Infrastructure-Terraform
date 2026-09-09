environment     = "staging"
location        = "UK South"
project_acronym = "cmrc"
vnet_rg         = "RG-Connectivity"
vnet_name       = "VNET-UKS-CaseManagment-PreProd"
aad_sp_name     = "Azure Pipeline: CMRC-PreProd"

asp_auto_scale_enabled     = true
asp_zone_balancing_enabled = false

asp_linux_sku          = "P0v3" # Basic plan does not allow for deployment slots
asp_linux_worker_count = 1

asp_windows_sku          = "P0v4" # Basic plan does not allow for deployment slots
asp_windows_worker_count = 1

/*
API 5xx rate alert:
Ignore low-volume periods where failure percentage is statistically misleading.
Alert when at least 10 real requests occur and >=20% return HTTP 5xx.
Filter out the consistent health check requests to the /Status endpoint.
*/
alert_api_5xx_total_requests_threshold = 10
alert_api_5xx_failure_rate_threshold   = 20
