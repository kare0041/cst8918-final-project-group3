# Common
variable "location"            { type = string }
variable "resource_group_name" { type = string }

# ACR
variable "acr_name" {
  type        = string
  description = "Globally-unique ACR name (5-50 lowercase alphanumerics)"
  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.acr_name))
    error_message = "acr_name must be 5-50 chars, lowercase letters and numbers only."
  }
}
variable "acr_sku"           { type = string, default = "Basic" }
variable "acr_admin_enabled" { type = bool,   default = true }

# Redis (test/prod)
variable "redis_test_name" {
  type        = string
  description = "Redis name for TEST"
  validation {
    condition     = can(regex("^[A-Za-z0-9-]{1,63}$", var.redis_test_name))
    error_message = "Redis name must be 1-63 chars, letters/numbers/hyphens."
  }
}

variable "redis_prod_name" {
  type        = string
  description = "Redis name for PROD"
  validation {
    condition     = can(regex("^[A-Za-z0-9-]{1,63}$", var.redis_prod_name))
    error_message = "Redis name must be 1-63 chars, letters/numbers/hyphens."
  }
}

variable "redis_capacity"             { type = number, default = 1 }
variable "redis_family"               { type = string, default = "C" }
variable "redis_sku"                  { type = string, default = "Basic" }
variable "redis_non_ssl_port_enabled" { type = bool,   default = true }

# Kubelet identity object IDs from AKS module outputs
variable "aks_test_kubelet_object_id" { type = string }
variable "aks_prod_kubelet_object_id" { type = string }
