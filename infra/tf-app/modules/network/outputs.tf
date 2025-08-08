output "vnet_name" {
  value = azurerm_virtual_network.main_vnet.name
}
output "resource_group_name" {

  value = azurerm_resource_group.network_rg.name

}

output "test_subnet_id" {

  value = azurerm_subnet.test.id

}

output "prod_subnet_id" {

  value = azurerm_subnet.prod.id

}

 output "id"                    { value = azurerm_kubernetes_cluster.this.id }
output "name"                  { value = azurerm_kubernetes_cluster.this.name }
output "kubelet_object_id"     { value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id }
output "kubernetes_version"    { value = azurerm_kubernetes_cluster.this.kubernetes_version }
