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

output "azurerm_postgresql_flexible_server_key_vault" {
  value = azurerm_key_vault.this.name
}

output "azurerm_postgresql_flexible_server_key_vault_key" {
  value = azurerm_key_vault_key.this.name
}

output "pgclient_identity_client_id" {
  value = azurerm_user_assigned_identity.pgclient.client_id
}

output "pgserver_identity_client_id" {
  value = azurerm_user_assigned_identity.pgserver.client_id
}

# output "vm_ip_address" {
#   value = azurerm_public_ip.this.ip_address
# }
