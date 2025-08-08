
# ---------- ACR ----------
resource "azurerm_container_registry" "weather_app_acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

# ---------- Redis (TEST) ----------
resource "azurerm_redis_cache" "redis_test" {
  name                = var.redis_test_name
  location            = var.location
  resource_group_name = var.resource_group_name

  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku

  non_ssl_port_enabled = var.redis_non_ssl_port_enabled
}

# ---------- Redis (PROD) ----------
resource "azurerm_redis_cache" "redis_prod" {
  name                = var.redis_prod_name
  location            = var.location
  resource_group_name = var.resource_group_name

  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku

  non_ssl_port_enabled = var.redis_non_ssl_port_enabled
}

# ---------- ACR Pull for AKS TEST ----------
resource "azurerm_role_assignment" "aks_test_acr_pull" {
  scope                = azurerm_container_registry.weather_app_acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_test_kubelet_object_id

  lifecycle {
    ignore_changes = [principal_id, role_definition_name, scope]
  }
}

# ---------- ACR Pull for AKS PROD ----------
resource "azurerm_role_assignment" "aks_prod_acr_pull" {
  scope                = azurerm_container_registry.weather_app_acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_prod_kubelet_object_id

  lifecycle {
    ignore_changes = [principal_id, role_definition_name, scope]
  }
}
