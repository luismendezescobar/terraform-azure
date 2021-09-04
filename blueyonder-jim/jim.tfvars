env                             ="dev"
subguid                         ="3258efe1-d8e7-4e11-aa41-7ece0bcd7d88"
azure_location                  ="westus"
region                          ="wus"
web_node_count                  =1
app_node_count                  =1
azure_subnet_id                 ="/subscriptions/3258efe1-d8e7-4e11-aa41-7ece0bcd7d88/resourceGroups/rg-west-ETS_NETWORK/providers/Microsoft.Network/virtualNetworks/vnet-west-MMS-SharedServices/subnets/MMS-Development"
azure_resource_group_name       ="rg-blueyonder-dev"
core_image_reference            ="/subscriptions/bf8f2b46-7581-485d-a21e-9ecfc670b79e/resourceGroups/rg-Core-SIG/providers/Microsoft.Compute/galleries/CoreSigProd/images/Windows-2019-CIS/versions/2021.07.15"
node_size                       ="Standard_D4s_v3"
appabbrev                       ="by"
local_vm_password               ="Mcke$$onm3!123"
bootdiags_primary_blob_endpoint ="https://rgjjordanvmnamediag.blob.core.windows.net"
ad_vm_adminuserorgroup          = "jjordan100"
db_name                         = "dazuswssbysc01"
db_node_size                    = "Standard_D8as_v4"

resource_tags                   = {
    core-env        = "dev"
    CostCenter      = "n/a"
    core-app-owner  = "ejddl20"
    core-data-owner = "ejddl20"
    core-tech-owner = "s4735vt-michael.malake@cypressmed.com"
    core-app-name   = "Blue Yonder WMS DEV"
    BAPorSLA        = "n/a"
  }



