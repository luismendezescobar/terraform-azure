provider "azurerm" {   #this can be in blank too
    version=2.72             
  
}
terraform{
    backend "azurerm"{
        resource_group_name ="1-1b461b3a-playground-sandbox"   #the resource group name needs to be copied from the playground as it's not possible to create resource groups
        storage_account_name="storage4terra8172021"                #you have to made up this name everytime as it needs to be different, I suggest the date of the day
        container_name      ="statefile"
        key                 ="terraform.tfstate"
    }
}

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
#}

#with this one we are going to create a storage account
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