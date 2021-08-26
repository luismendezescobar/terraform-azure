resource "azurerm_public_ip" "static" {
  name                         = "${var.prefix}-ad-ppip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method = "Static"
}

resource "azurerm_network_interface" "primary" {
  name                    = "${var.prefix}-dc-primary"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  internal_dns_name_label = "${local.virtual_machine_name}"

  ip_configuration {
    name                          = "primary"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
    public_ip_address_id          = "${azurerm_public_ip.static.id}"
  }
}









