variable "location" {
  type        = string
  description = "Azure location"
}


variable "network_rg_name" {
  description = "The name of the resource group for networking"
  type        = string
  default     = "cst8918-final-project-group-3"
}

variable "main_vnet_name" {
  description = "The name of the main virtual network"
  type        = string
  default     = "grp3-vnet"
}

variable "cluster_name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment" { type = string } # "test" | "prod"

# Node pool sizing
variable "enable_auto_scaling" { type = bool  default = false }
variable "node_count"          { type = number default = 1 }
variable "min_count"           { type = number default = 1 }
variable "max_count"           { type = number default = 1 }

# SKU / version
variable "vm_size"             { type = string default = "Standard_B2s" }
variable "kubernetes_version"  { type = string default = "1.32.0" }

