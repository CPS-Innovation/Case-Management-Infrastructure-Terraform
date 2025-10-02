terraform {
  required_version = "=1.11.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}
