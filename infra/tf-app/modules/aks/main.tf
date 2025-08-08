############################################
# Terraform + Provider
############################################
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112"
    }
  }
}

provider "azurerm" {
  features {}
}

############################################
# Variables (edit defaults if you want)
############################################
variable "location" {
  description = "Azure region"
  type        = string
  default     = "canadaeast"
}

variable "network_rg_name" {
  description = "Resource Group for network + AKS"
  type        = string
  default     = "cst8918-final-project-group-3"
}

variable "main_vnet_name" {
  description = "VNet name"
  type        = string
  default     = "g3-vnet"
}

# AKS settings
variable "kubernetes_version" {
  description = "AKS version (ensure it's supported in your region)"
  type        = string
  default     = "1.32.0"
}

variable "vm_size" {
  description = "AKS node size"
  type        = string
  default     = "Standard_B2s"
}

############################################
# Resource Group + Network
############################################
resource "azurerm_resource_group" "network_rg" {
  name     = var.network_rg_name
  location = var.location
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = var.main_vnet_name
  address_space       = ["10.0.0.0/14"]
  location            = var.location
  resource_group_name = azurerm_resource_group.network_rg.name
}

resource "azurerm_subnet" "prod" {
  name                 = "prod"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test" {
  name                 = "test"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "dev" {
  name                 = "dev"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "admin" {
  name                 = "admin"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.3.0.0/16"]
}

############################################
# AKS - Test (single node, no autoscaling)
############################################
resource "azurerm_kubernetes_cluster" "aks_test" {
  name                = "aks-test-g3"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  dns_prefix          = "aks-test-g3"

  kubernetes_version  = var.kubernetes_version
  role_based_access_control_enabled = true

  identity { type = "SystemAssigned" }

  default_node_pool {
    name                 = "system"
    vm_size              = var.vm_size
    node_count           = 1
    orchestrator_version = var.kubernetes_version
    vnet_subnet_id       = azurerm_subnet.test.id
  }

  network_profile {
    # Using Azure CNI for VNet subnet attachment
    network_plugin = "azure"
  }

  tags = {
    environment = "test"
    module      = "aks"
  }
}

############################################
# AKS - Prod (autoscaling 1..3)
############################################
resource "azurerm_kubernetes_cluster" "aks_prod" {
  name                = "aks-prod-g3"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  dns_prefix          = "aks-prod-g3"

  kubernetes_version  = var.kubernetes_version
  role_based_access_control_enabled = true

  identity { type = "SystemAssigned" }

  default_node_pool {
    name                 = "system"
    vm_size              = var.vm_size
    enable_auto_scaling  = true
    min_count            = 1
    max_count            = 3
    orchestrator_version = var.kubernetes_version
    vnet_subnet_id       = azurerm_subnet.prod.id
  }

  network_profile {
    network_plugin = "azure"
  }

  # When autoscaling is enabled, AKS will change node_count dynamically.
  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }

  tags = {
    environment = "prod"
    module      = "aks"
  }
}

############################################
# Outputs
############################################
output "rg_name" {
  value = azurerm_resource_group.network_rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main_vnet.name
}

output "subnets" {
  value = {
    prod  = azurerm_subnet.prod.name
    test  = azurerm_subnet.test.name
    dev   = azurerm_subnet.dev.name
    admin = azurerm_subnet.admin.name
  }
}

output "aks_test_name" {
  value = azurerm_kubernetes_cluster.aks_test.name
}

output "aks_prod_name" {
  value = azurerm_kubernetes_cluster.aks_prod.name
}
