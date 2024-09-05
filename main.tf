provider "azurerm" {
  features {}

  subscription_id = "your-subscription-id"
  client_id       = "your-client-id"
  client_secret   = "your-client-secret"
  tenant_id       = "your-tenant-id"
}
resource "azurerm_resource_group" "rg" {
  name     = "env1-network-rg"
  location = "North Europe"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsgassoc"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "env1-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.128.6.0/24"]
  dns_servers         = ["10.128.6.8", "10.128.6.9"]

  subnet {
    name           = "pear1"
    address_prefixes = ["10.128.6.64/26"]
  }

  subnet {
    name           = "diamond"
    address_prefixes = ["10.128.6.128/25"]
    security_group = azurerm_network_security_group.nsg.id
  }

  tags = {
    environment = "Production"
  }
}