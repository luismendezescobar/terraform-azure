variable "region"{
    default="westus"                     #this has to be same region as resource group
    description="Azure Region"
}
variable "ResourceGroup"{
    default="185-7f98aa58-create-azure-nsgs-with-terraform-8w8"
    description="Here goes the resource group for the storage account. copy the default from the play ground"
}

variable "Storage_Account_name"{
    default="accountfortoday8182021"
    description="Here goes the resource group for the storage account, it needs to be unique, so copy with the date"
}



