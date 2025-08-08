output "acr_login_server" {
  description = "ACR login server (e.g., <name>.azurecr.io)"
  value       = azurerm_container_registry.weather_app_acr.login_server
}

output "acr_id" {
  description = "ACR resource ID"
  value       = azurerm_container_registry.weather_app_acr.id
}

output "redis_test_hostname" {
  description = "Redis TEST hostname"
  value       = azurerm_redis_cache.redis_test.hostname
}

output "redis_prod_hostname" {
  description = "Redis PROD hostname"
  value       = azurerm_redis_cache.redis_prod.hostname
}
