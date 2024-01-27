data "azuread_service_principal" "pytest" {
  display_name = "pytest"
}

resource "azurerm_role_assignment" "pgclient_ra" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.pgclient.principal_id

  depends_on = [
    azurerm_key_vault.this
  ]
}

resource "azurerm_role_assignment" "pgserver_ra" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.pgserver.principal_id

  depends_on = [
    azurerm_key_vault.this
  ]
}

resource "azurerm_role_assignment" "admin_ra" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_key_vault.this
  ]
}

# Let service principal access postgres-flex
resource "azurerm_role_assignment" "pytest_pg_ra" {
  scope                = azurerm_postgresql_flexible_server.this.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.pytest.client_id
  depends_on = [
    azurerm_postgresql_flexible_server.this
  ]
}

# Let service principal access redis
resource "azurerm_role_assignment" "pytest_kv_ra" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.pytest.client_id
  depends_on = [
    azurerm_key_vault.this
  ]
}
