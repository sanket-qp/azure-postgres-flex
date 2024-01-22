locals {
  prefix               = "${var.alias}-${var.region}"
  location             = var.region
}

data "azurerm_client_config" "current" {}
