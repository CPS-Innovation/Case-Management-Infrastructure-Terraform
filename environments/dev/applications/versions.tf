terraform {
  required_version = "1.16.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
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
