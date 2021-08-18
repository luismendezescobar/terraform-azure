provider "azurerm" {   
    version=1.38          
}
 #version=2.72       
/*
terraform{
    backend "azurerm"{
        resource_group_name ="183-1b74fb5a-deploy-an-azure-file-share-with-terra"   #the resource group name needs to be copied from the playground as it's not possible to create resource groups
        storage_account_name="storage4terra8182021"                #you have to made up this name everytime as it needs to be different, I suggest the date of the day
        container_name      ="statefile"
        key                 ="terraform.tfstate"
    }
}
*/
#first run terraform init
#then terraform plan
#then terraform apply

#this one is to create a resource group but I'm going to comment it as it's not possible to create resource groups in the playground

#resource "azure_resource_group" "rg" {
#    name="TFResourceGroup"
#    location="eastus"
#    tags={         #you can include some tags too
#        environment="terraform"
#        deployedby   ="Admin"
#    }
#}ter

#with this one we are going to create a storage account
/*
resource "azurerm_storage_account" "sa"{
    name=var.Storage_Account_name
    resource_group_name=var.ResourceGroup
    location=var.region
    account_tier="Standard"
    account_replication_type="GRS"
    tags={
        environment="Terraform Storage"
        CreatedBy= "Luis Mendez"
    }
}
*/

resource "azurerm_storage_account" "lab" {
  name                     = var.Storage_Account_name
  resource_group_name      = var.ResourceGroup
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags={
        environment="Terraform Storage"
        CreatedBy= "Luis Mendez"
    }
}

resource "azurerm_storage_container" "lab" {
  name                  = "blobcontainer4lab"
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "lab" {
  name                   = "TerraformBlob"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.lab.name
  type                   = "Block"
}
resource "azurerm_storage_share" "lab" {
  name                 = "terraformshare"  
  storage_account_name = azurerm_storage_account.lab.name
  quota                = 50
}
#################################################################################################################
#create network security groups

resource "azurerm_network_security_group" "nsg" {
  name                = "LabNSG"
  location            = var.region
  resource_group_name = var.ResourceGroup
}

resource "azurerm_network_security_rule" "example1-allow80" {
  name                        = "Web80"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.ResourceGroup
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "example2-deny8080" {
  name                        = "Web8080"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "8080"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.ResourceGroup
  network_security_group_name = azurerm_network_security_group.nsg.name
}

  resource "azurerm_network_security_rule" "example3-allow22" {
  name                        = "SSH"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.ResourceGroup
  network_security_group_name = azurerm_network_security_group.nsg.name
}

####################################################################################################################
# Create virtual network
resource "azurerm_virtual_network" "TFNet" {
    name                = "network8182021"
    address_space       = ["10.0.0.0/16"]
    location            = var.region
    resource_group_name = var.ResourceGroup

    tags = {
        environment = "Terraform Networking"
    }
    subnet{                              
          security_group = azurerm_network_security_group.nsg.name
    }
}

# Create subnet
resource "azurerm_subnet" "tfsubnet" {
    name                 = "LabSubnet"
    resource_group_name = var.ResourceGroup
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefix       = "10.0.1.0/24"
}
resource "azurerm_subnet" "tfsubnet2" {
    name                 = "LabSubnet2"
    resource_group_name = var.ResourceGroup
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefix       = "10.0.2.0/24"
}
#########################################################################################################################
