output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.this.name
}

output "postgresql_flexible_server_admin_password" {
  sensitive = true
  value     = azurerm_postgresql_flexible_server.this.administrator_password
}
