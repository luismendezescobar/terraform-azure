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



module "windows-client" {
  source                    = "./modules/windows-client"
  resource_group_name       = "${data.azurerm_resource_group.test.name}"
  location                  = "${data.azurerm_resource_group.test.location}"
  prefix                    = "${var.prefix}"
  subnet_id                 = "${module.network.domain_clients_subnet_id}"
  active_directory_domain   = "${var.prefix}.local"
  active_directory_username = "${var.admin_username}"
  active_directory_password = "${var.admin_password}"
  admin_username            = "${var.admin_username}"
  admin_password            = "${var.admin_password}"
}

output "windows_client_public_ip" {
  value = "${module.windows-client.public_ip_address}"
}
