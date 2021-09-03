// NOTE: in a Production Environment you're likely to have Network Security Rules
// which lock down traffic between Subnets. These are omited below to keep the
// examples easy to understand - and should be added before being used in Production.

data "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"  
}

resource "azurerm_subnet" "domain-clients" {
  name                 = "domain-clients"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${data.azurerm_virtual_network.main.name}"
  address_prefix     = "10.0.2.0/24"
}
