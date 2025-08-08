provider "azurerm" {
  features {}
}

module "network" {
  source   = "./modules/network"
  location = var.location
}

module "aks" {
  source              = "./modules/aks"
  location            = var.location
  resource_group_name = module.network.resource_group_name
  vnet_subnet_id_test = module.network.test_subnet_id
  vnet_subnet_id_prod = module.network.prod_subnet_id
  test_aks_name       = "grp3-aks-test"
  prod_aks_name       = "grp3-aks-prod"
}
