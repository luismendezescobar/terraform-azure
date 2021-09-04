# Configure the Azure provider
provider "azurerm" {
    version = ">= 1.32.0"
	  subscription_id  = var.subguid
    tenant_id       = "da67ef1b-ca59-4db2-9a8c-aa8d94617a16"
    features {}
}


# Create a resource group
/*
resource "azurerm_resource_group" "rg" {
  name     = var.azure_resource_group_name
  location = var.azure_location
  tags     = var.resource_tags
}
*/
  
data "azurerm_resource_group" "rg" {
  name     = var.azure_resource_group_name
}




resource "azurerm_storage_account" "lab" {
  name                     = "testluis09032021"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags={
        environment="Terraform Storage"
        CreatedBy= "Luis Mendez"
    }
}
resource "azurerm_storage_container" "lab" {
  name                  = "bootblob"
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}
/*
resource "azurerm_storage_blob" "lab" {
  name                   = "BootBlob"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.lab.name
  type                   = "Block"
}
*/

output "storageaccounturl" {
  value = azurerm_storage_account.lab.id
}


output "bloburl" {
  value = azurerm_storage_container.lab.id
}
