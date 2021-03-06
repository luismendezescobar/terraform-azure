provider "azurerm" {   
    version=1.38          
}

locals {
  resource_group_name = "${var.prefix}-resources"
}

data "azurerm_resource_group" "test" {
  name     = var.resource_group
}

module "network" {
  source              = "./modules/network"
  prefix              = "${var.prefix}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"
  location            = "${data.azurerm_resource_group.test.location}"
}

module "active-directory-domain" {
  source                        = "./modules/active-directory"
  resource_group_name           = "${data.azurerm_resource_group.test.name}"
  location                      = "${data.azurerm_resource_group.test.location}"
  prefix                        = "${var.prefix}"
  subnet_id                     = "${module.network.domain_controllers_subnet_id}"
  active_directory_domain       = "${var.prefix}.local"
  active_directory_netbios_name = "${var.prefix}"
  admin_username                = "${var.admin_username}"
  admin_password                = "${var.admin_password}"
}

output "public_ip_address_ad_server" {
  value = "${module.active-directory-domain.public_ip_address_ad}"
}

