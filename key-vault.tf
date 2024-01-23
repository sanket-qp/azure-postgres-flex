resource "azurerm_key_vault" "this" {
  name                        = "${local.prefix}-keyvault"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enable_rbac_authorization   = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Backup",
      "Create",
      "Delete",
      "Decrypt",
      "Encrypt",
      "Get",
      "List",
      "Import",
      "Rotate",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Verify",
      "WrapKey",
      "Release",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.pgserver.principal_id

    key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "WrapKey",
      "UnwrapKey"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set"
    ]
  }
}

resource "azurerm_key_vault_key" "this" {
  name         = "${local.prefix}-keyvault-key"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
    ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}


resource "azurerm_role_assignment" "pgclient_ra" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.pgclient.principal_id
}

resource "azurerm_role_assignment" "pgserver_ra" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.pgserver.principal_id
}

resource "azurerm_role_assignment" "admin_ra" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
