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
# Create virtual network and subnetworks



resource "azurerm_virtual_network" "TFNet" {
    name                = "network818202101"
    address_space       = ["10.0.0.0/16"]
    location            = var.region
    resource_group_name = var.ResourceGroup

    tags = {
        environment = "Terraform Networking"
    }
    dynamic "subnet"{                              
        for_each=var.subnets
        content{
            name           = subnet.value.name
            address_prefix = subnet.value.address_prefix
            security_group = azurerm_network_security_group.nsg.id
        }
    }
}

#########################################################################################################################
############# Create a VM ##########################################################################################
#Deploy Public IP
resource "azurerm_public_ip" "example" {
  name                = "pubip1"
  location            = var.region
  resource_group_name = var.ResourceGroup
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
#we need to get information of the subnet that we are going to use so we use data
/*
data "azurerm_subnet" "tfsubnet"{
    name="LabSubnet"
    virtual_network_name = "network818202101"
    resource_group_name = var.ResourceGroup
}
*/
# Create subnet for vm
/*
resource "azurerm_subnet" "tfsubnet" {
    name                 = "LabSubnet4"
    resource_group_name = var.ResourceGroup
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefix       = "10.0.4.0/24"
}
*/
#Create NIC
#this is to get a map with all the subnets that we have
locals{
    all_subnets={for sub in azurerm_virtual_network.TFNet.subnet: sub.name => sub }

}
/*the output will be like this
~ subnets = {
    - LabSubnet  = {
        - address_prefix = "10.0.1.0/24"
        - id             = "/subscriptions/964df7ca-3ba4-48b6-a695-1ed9db5723f8/resourceGroups/1-5222d440-playground-sandbox/providers/Microsoft.Network/virtualNetworks/network818202101/subnets/LabSubnet"
        - name           = "LabSubnet"
        - security_group = "/subscriptions/964df7ca-3ba4-48b6-a695-1ed9db5723f8/resourceGroups/1-5222d440-playground-sandbox/providers/Microsoft.Network/networkSecurityGroups/LabNSG"
      }
    - LabSubnet2 = {
        - address_prefix = "10.0.2.0/24"
        - id             = "/subscriptions/964df7ca-3ba4-48b6-a695-1ed9db5723f8/resourceGroups/1-5222d440-playground-sandbox/providers/Microsoft.Network/virtualNetworks/network818202101/subnets/LabSubnet2"
        - name           = "LabSubnet2"
        - security_group = "/subscriptions/964df7ca-3ba4-48b6-a695-1ed9db5723f8/resourceGroups/1-5222d440-playground-sandbox/providers/Microsoft.Network/networkSecurityGroups/LabNSG"
      }
  }
*/


#output "subnets"{value=local.all_subnets}
/*
output "subnets"{
  value = [for name in local.all_subnets : name.id]
}*/
output "subnets"{value=local.all_subnets.LabSubnet.id}


resource "azurerm_network_interface" "example" {
  name                = "mynic"  
  location            = var.region
  resource_group_name = var.ResourceGroup

    ip_configuration {
    name                          = "ipconfig1"        
    #subnet_id = azurerm_subnet.tfsubnet.id
    subnet_id = local.all_subnets.LabSubnet.id
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

#Create Boot Diagnostic Account
resource "azurerm_storage_account" "sa" {
  name                     = "forgedbootdiag" 
  resource_group_name      = var.ResourceGroup
  location                 = var.region
   account_tier            = "Standard"
   account_replication_type = "LRS"

   tags = {
    environment = "Boot Diagnostic Storage"
    CreatedBy = "Admin"
   }
  }

#Create Virtual Machine
resource "azurerm_virtual_machine" "example" {
  name                  = "my-machine"  
  location              = var.region
  resource_group_name   = var.ResourceGroup  
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "50"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "my-machine"
    admin_username = "vmadmin"
    admin_password = "Password12345!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
    }
}

