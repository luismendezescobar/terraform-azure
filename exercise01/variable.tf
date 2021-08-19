variable "region"{
    default="centralus"                     #this has to be same region as resource group
    description="Azure Region"
}
variable "ResourceGroup"{
    default="185-0a8bb5df-create-azure-nsgs-with-terraform-8w8"
    description="Here goes the resource group for the storage account. copy the default from the play ground"
}

variable "Storage_Account_name"{
    default="accountfortoday8182021"
    description="Here goes the resource group for the storage account, it needs to be unique, so copy with the date"
}


variable "subnets" {
    type=list(object({        
        name           = string
        address_prefix  = string
        security_group  = string        
    }))


    default=[
        {
            name           = "LabSubnet"
            address_prefix = "10.0.3.0/24"
            security_group = ""
        },
        {
            name           = "LabSubnet2"
            address_prefix = "10.0.3.0/24"
            security_group = ""
        }                
    ]
}
