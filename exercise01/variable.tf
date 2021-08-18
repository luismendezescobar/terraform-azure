variable "region"{
    default="westus"
    description="Azure Region"
}
variable "ResourceGroup"{
    default="183-88a89a1a-deploy-an-azure-file-share-with-terra"
    description="Here goes the resource group for the storage account. copy the default from the play ground"
}

variable "Storage_Account_name"{
    default="accountfortoday8172021"
    description="Here goes the resource group for the storage account, it needs to be unique, so copy with the date"
}
