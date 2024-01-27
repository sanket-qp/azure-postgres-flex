# data "azurerm_virtual_network" "vnet" {
#   name                 = "${local.prefix}-vnet"
#   resource_group_name  =  "${local.prefix}-rg"
#   depends_on = [
#     azurerm_virtual_network.this
#   ]
# }

# data "azurerm_subnet" "this" {
#     name                 = "${data.azurerm_virtual_network.vnet.subnets[0]}"
#     virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
#     resource_group_name  = "${data.azurerm_virtual_network.vnet.resource_group_name}"
#     depends_on = [
#         azurerm_virtual_network.this
#     ]
# }

# resource "azurerm_public_ip" "this" {
#   name                = "${local.prefix}-public-ip"
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   allocation_method   = "Dynamic"
#   depends_on = [
#     azurerm_virtual_network.this
#   ]
# }

# resource "azurerm_network_interface" "this" {
#   name                = "${local.prefix}-nic"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name

#   ip_configuration {
#     name                          = "${local.prefix}-ipconfig"
#     subnet_id                     = data.azurerm_subnet.this.id
#     # subnet_id                     = azurerm_virtual_network.this.subnets[0]
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.this.id
#   }

#   depends_on = [
#     azurerm_public_ip.this
#   ]
# }

# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "this" {
#   network_interface_id      = azurerm_network_interface.this.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

# resource "azurerm_linux_virtual_machine" "this" {
#   name                = "${local.prefix}-vm"
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   size                = "Standard_B1ls"
#   admin_username      = "pgdemo"
#   network_interface_ids = [
#     azurerm_network_interface.this.id,
#   ]

#   identity {
#     type         = "UserAssigned"
#     identity_ids = tolist([azurerm_user_assigned_identity.pgclient.id])
#   }

#   admin_ssh_key {
#     username   = "pgdemo"
#     public_key = tls_private_key.this.public_key_openssh
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }

#   depends_on = [
#     azurerm_virtual_network.this,
#     azurerm_user_assigned_identity.pgclient,
#     azurerm_network_interface.this,
#     tls_private_key.this
#   ]
# }
