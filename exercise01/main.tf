provider "azurerm" {
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