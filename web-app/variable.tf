variable "region"{
    default="Central US"                     #this has to be same region as resource group
    description="Azure Region"
}
variable "ResourceGroup"{
    default="191-066379bb-deploy-a-web-application-with-terrafo"
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
            address_prefix = "10.0.1.0/24"
            security_group = ""
        },
        {
            name           = "LabSubnet2"
            address_prefix = "10.0.2.0/24"
            security_group = ""
        },                
        {
            name           = "LabSubnet3"
            address_prefix = "10.0.3.0/24"
            security_group = ""
        },   
    ]
}
