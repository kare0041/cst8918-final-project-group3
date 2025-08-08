provider "azurerm" { features {} }

variable "location" { default = "canadaeast" }
variable "rg_name"  { default = "cst8918-final-project-group-3" }

# network + acr modules assumed already exist; shown here as locals/outputs
# module "network" { ... }
# module "acr"     { ... }  # outputs: login_server, id

module "aks_test" {
  source              = "../modules/aks"
  location            = var.location
  resource_group_name = var.rg_name
  cluster_name        = "aks-test-g3"
  environment         = "test"

  enable_auto_scaling = false
  node_count          = 1
  vm_size             = "Standard_B2s"
  kubernetes_version  = "1.32.0"
  acr_id              = module.acr.id
}

module "aks_prod" {
  source              = "../modules/aks"
  location            = var.location
  resource_group_name = var.rg_name
  cluster_name        = "aks-prod-g3"
  environment         = "prod"

  enable_auto_scaling = true
  min_count           = 1
  max_count           = 3
  vm_size             = "Standard_B2s"
  kubernetes_version  = "1.32.0"
  acr_id              = module.acr.id
}
