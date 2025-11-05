terraform {
  required_version = "1.13.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.44.0"
    }
  }
}

provider "azurerm" {
  features {}
}
