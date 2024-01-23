resource "azurerm_subnet" "this" {
  name                 = "${local.prefix}-postgres-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
resource "azurerm_private_dns_zone" "this" {
  name                = "${local.prefix}.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  resource_group_name   = azurerm_resource_group.this.name
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "${local.prefix}-psqlflexibleserver"
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  version                = "15"
  delegated_subnet_id    = azurerm_subnet.this.id
  private_dns_zone_id    = azurerm_private_dns_zone.this.id
  administrator_login    = "pgadmin"
  administrator_password = "HelloPgFlex123$"
  zone                   = "1"

#   customer_managed_key {
#     key_vault_key_id = azurerm_key_vault_key.this.id
#     primary_user_assigned_identity_id = azurerm_user_assigned_identity.pgclient.id
#   }

  storage_mb = 32768

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_key_vault_key.this, azurerm_user_assigned_identity.pgclient, azurerm_private_dns_zone_virtual_network_link.this]
}
