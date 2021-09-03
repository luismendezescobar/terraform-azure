# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "rgbuild" {
  name     = "rg-build01"
  location = "West US"
}

resource "azurerm_template_deployment" "rgbuild" {
  name                = "acctesttemplate-03"
  resource_group_name = "${azurerm_resource_group.rgbuild.name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "Platform": {
            "allowedValues": [
                "Windows",
                "Linux"

            ],
            "type": "String",
            "metadata": {
                "description": "Select the OS type to deploy."
            }
        },

        "OSVersion": {
            "allowedValues": [
                "Windows-2012R2-CIS",
                "Windows-2016-CIS",
                "RHEL-7-CIS",
                "Ubuntu-1604-CIS",
                "CentOS-7-CIS",
                "SUSE-12-CIS"
            ],
            "type": "String",
            "metadata": {
                "description": "The OS version for the VM. This will pick a fully patched image of this given Windows or Linux version. Allowed values:  RHEL7-CIS, Ubuntu-1604-CIS, Centos7-CIS, Win2012R2-CIS, Win2008R2-CIS, and Win2016-CIS"
            }
        },
        "vmAdminUsername": {
            "type": "String",
            "metadata": {
                "description": "The Local administrator or Sudoers Account. Admin, Administrator or root is not Allowed"
            }
        },
        "vmAdminPassword": {
            "minLength": 12,
            "type": "SecureString",
            "metadata": {
                "description": "Password must have 3 of the following: 1 lower case Character, 1 upper case character, 1 number, and 1 special Character that is not \\ or '-'."
            }
        },
        "AvailabilitySet": {
            "allowedValues": [
                "Yes",
                "No"
            ],
            "type": "string",
            "metadata": {
                "description": "Select whether the VM should be in a availability set or not."
            }
        },

        "AvSetName": {
            "type": "string",
             "defaultValue": "standardAvSet",
            "metadata": {
                "description": "Name of AvSet."
            }
        },
         "platformFaultDomainCount": {
            "type": "int",
             "defaultValue": 2,
            "metadata": {
                "description": "AvSet faultdomain count"
            }
        },
            "platformUpdateDomainCount": {
            "type": "int",
             "defaultValue": 5,
            "metadata": {
                "description": "AvSet platformupdateDomain count"
            }
        },
        "BusinessUnit": {
            "allowedValues": [
                "CM: Care Management",
                "CORP: Corporate",
                "EI - Enterprise Intelligence",
                "EMR: Electronic Medical Records",
                "FM: Financial Management",
                "GEN: General Medical",
                "HC: Homecare",
                "IWS: Imaging & Workflow Solutions",
                "MCCA SS: MCCA Shared Services",
                "McKesson Canada",
                "MHSS: MHS Shared Services",
                "MIT: McKesson Information Technology",
                "MPRS McK Patient Relationship Solutions",
                "MPS: McKesson Pharmacy Systems",
                "MS: Managed Services",
                "MSH - HQ: Headquarters",
                "MTS ASP Hosting",
                "MTSS: MTS Shared Services",
                "Pharma BI/BW",
                "Pharma CRM",
                "Pharma EAI/Websphere",
                "Pharma: Pharmaceutical",
                "Pharma SAP",
                "PPS: Physician Practice Solutions",
                "RHF: RelayHealth Financial",
                "RHPH: RelayHealth - Pharmacy",
                "RMS: Revenue Management Solutions",
                "Pharma:Gx",
                "Marco Helix"
            ],
            "type": "String",
            "metadata": {
                "description": "BU that is requesting this server."
            }
        },
        "SID": {
            "minLength": 3,
            "maxLength": 7,
            "type": "String",
            "metadata": {
                "description": "EID or SID of a primary contact responsible for this server."
            }
        },
        "virtualMachineName": {
            "minLength": 3,
            "maxLength": 15,
            "type": "String",
            "metadata": {
                "description": "VM Server Name.  Example: Texas or Manine.  the template will concatenate  ' up to 6 charaters from your virtual machine name to generate a unique VM name."
            }
        },
        "virtualMachineSize": {
            "defaultValue": "Standard_DS2_v2",
            "allowedValues": [
                "Standard_A1_v2",
                "Standard_A2_v2",
                "Standard_A4_v2",
                "Standard_A4m_v2",
                "Standard_A8_v2",
                "Standard_A8m_v2",
                "Standard_F1",
                "Standard_F2",
                "Standard_F4",
                "Standard_F8",
                "Standard_F16",
                "Standard_DS5_v2",
                "Standard_D1_v2",
                "Standard_D11_v2",
                "Standard_D12_v2",
                "Standard_D14_v2",
                "Standard_D2_v2",
                "Standard_D3_v2",
                "Standard_D4_v2",
                "Standard_DS12_v2",
                "Standard_DS4_v2",
                "Standard_DS4_v2",
                "Standard_DS2_v2",
                "Standard_D2_v3",
                "Standard_DS13_v2",
                "Standard_DS11_v2",
                "Standard_E4-2s_v3",
                "Standard_E8-4s_v3",
                "Standard_E16-4s_v3",
                "Standard_G1",
                "Standard_G2"

            ],
            "type": "String",
            "metadata": {
                "description": "Please select a VM size."
            }
        },
        "Datadisk": {
            "defaultValue": "No",
            "allowedValues": [
                "Yes",
                "No"
            ],
            "type": "String",
            "metadata": {
                "description": "Select whether the VM should have a datadisk or not."
            }
        },
        "DataDisksizeInGB": {
            "defaultValue": 100,
            "type": "int",
            "metadata": {
                "description": "Size of each data disk in GB"
            }
        },
        "numberOfDataDisks": {
            "defaultValue": 0,
            "type": "Int",
            "metadata": {
                "description": "The number of data disks you want to attach to the VM"
            }
        },
        "vmstorageType": {
            "defaultValue": "Standard_LRS",
            "allowedValues": [
                "Standard_LRS",
                "Standard_GRS",
                "Standard_RAGRS",
                "Premium_LRS"
            ],
            "type": "String",
            "metadata": {
                "description": "Please select a VM Storage type."
            }
        },
        "existingVnetName": {
            "type": "String",
            "metadata": {
                "description": "Existing VirtualNetwork ."
            }
        },
        "existingVnetResourceGroupName": {
            "type": "String",
            "metadata": {
                "description": "resource group for Existing VirtualNetwork"
            }
        },
        "subnetName": {
            "type": "String",
            "metadata": {
                "description": "Existing Subnet"
            }
        },
        "DomainJoined": {
            "allowedValues": [
                "Yes",
                "No"
            ],
            "type": "String",
            "metadata": {
                "description": "Join Server to NAMCK domain yes or no"
            }
        },
        "BAP URL": {
            "defaultValue": "BAP1071",
            "type": "String",
            "metadata": {
                "description": "Please enter the Bap number or Bap Name. The purpose of this BAP is to enable visibility into business impacting outages for OneCloud Self-Managed customers. Per current policy - outages recorded against this BAP will not be represented on the current Public Cloud Scorecard which is limited to Fully-Managed systems only."
            }
        }
    },
    "variables": {
        "existingVNETName": "[parameters ('existingVnetName')]",
        "existingVNETResourceGroupName": "[parameters ('existingVnetResourceGroupName')]",
        "vnetRef": "[resourceId(subscription().subscriptionId, variables('existingVNETResourceGroupName'),'Microsoft.Network/virtualNetworks',variables('existingVNETName'))]",
        "subnetName": "[parameters('subnetName')]",
        "subnetRef": "[concat(variables('vnetRef'), '/subnets/', variables('subnetName'))]",
        "imageSku": "[parameters('OSVersion')]",
        "storageSku": "[parameters('vmstorageType')]",
        "nicName": "[concat(parameters('virtualMachineName'), substring(uniqueString(resourceGroup().id),0,9))]",
        "domainJoinOptions": "3",
        "domainToJoin": "na.corp.mckesson.com",
        "ouPath": "OU=AZ,OU=DM,OU=Delegated,DC=na,DC=corp,DC=mckesson,DC=com",
        "keyVaultRef": "/subscriptions/bf8f2b46-7581-485d-a21e-9ecfc670b79e/resourceGroups/zcontainerd/providers/Microsoft.KeyVault/vaults/dmjoin-kv",
        "domainusername": "dcay7pp",
        "domainpassword": "dcay7pppass",
        "BAP URL": "[parameters('BAP URL')]",
        "coreimages": "[concat ('core-images-', resourceGroup().location)]",
        "templatelink": "[concat('https://mckcore.blob.core.windows.net/agents/JoinADDomain/JoinADDomain/', concat(parameters('Platform'),'sigv1.json?sv=2017-07-29&ss=bf&srt=sco&sp=rl&se=2021-05-17T21:37:38Z&st=2018-05-17T13:37:38Z&spr=https&sig=tnad%2BHrvudctboHiw8LohtjnTc9RYTtUCRpJ5sVSie8%3D'))]"
    },
    "resources": [
        {
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[concat(variables('nicName'))]",
            "apiVersion": "2017-06-01",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "WinVirtualMachinesNic"
            },
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[variables('subnetRef')]"
                            }
                        }
                    }
                ]
            },
            "dependsOn": []
        },
        {
            "type": "Microsoft.Resources/deployments",
            "name": "linkedTemplate",
            "apiVersion": "2017-05-10",
            "properties": {
                "mode": "Incremental",
                "templateLink": {
                    "uri": "[variables('templatelink')]",
                    "contentVersion": "1.0.0.0"
                },
                "parameters": {
                    "virtualMachineName": {
                        "value": "[parameters('virtualMachineName')]"
                    },
                    "nicName": {
                        "value": "[variables('nicName')]"
                    },
                    "virtualMachinesize": {
                        "value": "[parameters('virtualMachineSize')]"
                    },
                    "vmAdminUsername": {
                        "value": "[parameters('vmAdminUsername')]"
                    },
                    "vmAdminPassword": {
                        "value": "[parameters('vmAdminPassword')]"
                    },
                    "SID": {
                        "value": "[parameters('SID')]"
                    },
                    "BAP URL": {
                        "value": "[parameters('BAP URL')]"
                    },
                    "domainToJoin": {
                        "value": "[variables('domainToJoin')]"
                    },
                    "domainUsername": {
                        "value": "[variables('domainUsername')]"
                    },
                    "DomainJoined": {
                        "value": "[parameters('DomainJoined')]"
                    },
                    "domainPassword": {
                        "reference": {
                            "keyVault": {
                                "id": "[variables('keyVaultRef')]"
                            },
                            "secretName": "[variables('domainpassword')]"
                        }
                    },
                    "ouPath": {
                        "value": "[variables('ouPath')]"
                    },
                    "OSVersion": {
                        "value": "[variables('imageSku')]"
                    },
                    "storageSku": {
                        "value": "[variables('storageSku')]"
                    },
                    "image location": {
                        "value": "[variables('coreimages')]"
                    },
                    "AvailabilitySet": {
                        "value": "[parameters('AvailabilitySet')]"
                    },
                    "AvSetName": {
                        "value": "[parameters('AvSetName')]"
                    },
                    "platformFaultDomainCount": {
                        "value": "[parameters('platformFaultDomainCount')]"
                    },
                     "platformUpdateDomainCount": {
                        "value": "[parameters('platformUpdateDomainCount')]"
                    },
                    "Platform": {
                        "value": "[parameters('Platform')]"
                    },
                    "DataDisksizeInGB": {
                        "value": "[parameters('DataDisksizeInGB')]"
                    },
                    "Datadisk": {
                        "value": "[parameters('Datadisk')]"
                    },
                    "numberOfDataDisks": {
                        "value": "[parameters('numberOfDataDisks')]"
                    },
                    "BusinessUnit": {
                        "value": "[parameters('BusinessUnit')]"
                    }
                }
            },
            "dependsOn": []
        }
    ],
    "outputs": {
        "platform": {
            "type": "String",
            "value": "[parameters('platform')]"
        },
        "connectionInfo": {
            "type": "String",
            "value": "[if(equals(parameters('platform'), 'Windows'), 'Use RDP to connect to the VM', 'Use SSH to connect to the VM')]"
        }
    }
}



DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block
  # replace the parameters below to fit your solution
  parameters {
    "SID"                           = ""  # replace
    "AvailabilitySet"               = "Yes"
    "BAP URL"                       = "BAP1071"
    "BusinessUnit"                  = "MIT: McKesson Information Technology"
    "DomainJoined"                  = "No"
    "OSVersion"                     = "Windows-2012R2-CIS" #replace
    "Platform"                      = "Windows"
    "virtualMachineSize"            = "Standard_DS2_v2"
    "virtualMachineName"            = "coremck-46" # replace
    "vmAdminUsername"               = "wsaadmin" # Repalce
    "existingVnetName"              = "vnet-westus-RxO-Prod-Unmanaged"  #replace
    "existingVnetResourceGroupName" = "rg-vnet-westus-RxO-Prod-Unmanaged"  #repalce
    "subnetName"                    = "SubNet-Uat-Prod-SQL"     #replace

    "vmAdminPassword" = ""  # replace
    "Datadisk"        = "No"
  }

  deployment_mode = "Incremental"
}
