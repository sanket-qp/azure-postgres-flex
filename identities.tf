resource "azurerm_user_assigned_identity" "pgclient" {
  location            = azurerm_resource_group.this.location
  name                = "${local.prefix}-postgres-client-mi"
  resource_group_name = azurerm_resource_group.this.name
}
