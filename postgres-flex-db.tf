resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = "${local.prefix}-db"
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
