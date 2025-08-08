provider "azurerm" {
  features {}
}

module "network" {
  source              = "./modules/network"
  location        = var.location
}
