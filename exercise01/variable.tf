variable "region"{
    default="eastus"                     #this has to be same region as resource group
    description="Azure Region"
}
variable "ResourceGroup"{
    default="156-ddfdcfc1-deploy-an-azure-storage-account-with"
    description="Here goes the resource group for the storage account. copy the default from the play ground"
}

variable "Storage_Account_name"{
    default="accountfortoday8172021"
    description="Here goes the resource group for the storage account, it needs to be unique, so copy with the date"
}
