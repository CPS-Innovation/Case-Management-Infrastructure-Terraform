terraform {
  required_version = "1.15.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.6.0"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}
