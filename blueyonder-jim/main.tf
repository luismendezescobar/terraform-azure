# Configure the Azure provider
provider "azurerm" {
    version = ">= 1.32.0"
	  subscription_id  = var.subguid
    tenant_id       = "da67ef1b-ca59-4db2-9a8c-aa8d94617a16"
    features {}
}


# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.azure_resource_group_name
  location = var.azure_location
  tags     = var.resource_tags
}

  

################################# Windows Virtual Machine Web ################
resource "azurerm_network_interface" "web" {
  name                = "nic-${lower(var.region)}-${lower(var.appabbrev)}-web-${lower(var.env)}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.azure_subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = true

  }
    tags                          = var.resource_tags
    count                         = var.web_node_count 
}

resource "azurerm_windows_virtual_machine" "web" {
  name                            = "${lower(var.appabbrev)}${lower(var.region)}-web-${lower(var.env)}${count.index}"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.node_size
  admin_username                  = "jjordan100"
  admin_password                  = var.local_vm_password
  network_interface_ids           = [azurerm_network_interface.web.*.id[count.index]]

  tags                            = var.resource_tags
  count                           = var.web_node_count

  os_disk {
    name                          = "${lower(var.appabbrev)}${lower(var.region)}web${lower(var.env)}${count.index}-os"
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
  }



    source_image_id               = var.core_image_reference
  
    allow_extension_operations    = "true"

# Uncomment for PROD 
# boot_diagnostics {
#    storage_account_uri           = var.bootdiags_primary_blob_endpoint
#  }


}

# add a data disk 
resource "azurerm_managed_disk" "datadisk" {
    name                            = "${azurerm_windows_virtual_machine.web[count.index].name}-data-disk01" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 200
    tags                            = var.resource_tags
    count                           = var.web_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk_attach" {
    count                           = var.web_node_count
    managed_disk_id                 = azurerm_managed_disk.datadisk[count.index].id
    virtual_machine_id              = azurerm_windows_virtual_machine.web[count.index].id
    lun                             = 1
    caching                         = "ReadWrite"
}



################################# Windows Virtual Machine  APP Server ################
resource "azurerm_network_interface" "app" {
  name                = "nic-${lower(var.region)}-${lower(var.appabbrev)}-app-${lower(var.env)}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.azure_subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = true

  }
    tags                          = var.resource_tags
    count                         = var.app_node_count 
}

resource "azurerm_windows_virtual_machine" "app" {
  name                            = "${lower(var.appabbrev)}${lower(var.region)}-app-${lower(var.env)}${count.index}"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.node_size
  admin_username                  = "jjordan100"
  admin_password                  = var.local_vm_password
  network_interface_ids           = [azurerm_network_interface.app.*.id[count.index]]

  tags                            = var.resource_tags
  count                           = var.app_node_count

  os_disk {
    name                          = "${lower(var.appabbrev)}${lower(var.region)}app${lower(var.env)}${count.index}-os"
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
  }



    source_image_id               = var.core_image_reference
  
    allow_extension_operations    = "true"

# Uncomment for PROD 
# boot_diagnostics {
#    storage_account_uri           = var.bootdiags_primary_blob_endpoint
#  }


}

# add a data disk 
resource "azurerm_managed_disk" "appdatadisk" {
    name                            = "${azurerm_windows_virtual_machine.app[count.index].name}-data-disk01" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 200
    tags                            = var.resource_tags
    count                           = var.app_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "appdatadisk_attach" {
    count                           = var.app_node_count
    managed_disk_id                 = azurerm_managed_disk.appdatadisk[count.index].id
    virtual_machine_id              = azurerm_windows_virtual_machine.app[count.index].id
    lun                             = 1
    caching                         = "ReadWrite"
}



################################# Windows Virtual Machine DB Server ################
resource "azurerm_network_interface" "db" {
  name                = "nic-${lower(var.db_name)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.azure_subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = true

  }
    tags                          = var.resource_tags
   # count                         = var.web_node_count 
}

resource "azurerm_windows_virtual_machine" "db" {
  name                            = var.db_name
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.db_node_size
  admin_username                  = "jjordan100"
  admin_password                  = var.local_vm_password
  network_interface_ids           = [azurerm_network_interface.db.id]

  tags                            = var.resource_tags
 # count                           = var.web_node_count

  os_disk {
    name                          = "${lower(var.db_name)}-os"
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
  }



    source_image_id               = var.core_image_reference
  
    allow_extension_operations    = "true"

# Uncomment for PROD 
# boot_diagnostics {
#    storage_account_uri           = var.bootdiags_primary_blob_endpoint
#  }


}

# add a data disk SQL Binaries
resource "azurerm_managed_disk" "sqlbindisk" {
    name                            = "${azurerm_windows_virtual_machine.db.name}-data-sql-binaries" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 10
    tags                            = var.resource_tags
    #count                           = var.web_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "sqlbindisk_attach" {
    #count                           = var.web_node_count
    managed_disk_id                 = azurerm_managed_disk.sqlbindisk.id
    virtual_machine_id              = azurerm_windows_virtual_machine.db.id
    lun                             = 1
    caching                         = "ReadWrite"
}

# add a data disk SQL database data
resource "azurerm_managed_disk" "sqldatadisk" {
    name                            = "${azurerm_windows_virtual_machine.db.name}-sqldata" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 120
    tags                            = var.resource_tags
    #count                           = var.web_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "sqldatadisk_attach" {
    #count                           = var.web_node_count
    managed_disk_id                 = azurerm_managed_disk.sqldatadisk.id
    virtual_machine_id              = azurerm_windows_virtual_machine.db.id
    lun                             = 2
    caching                         = "ReadWrite"
}

# add a data disk SQL database log
resource "azurerm_managed_disk" "sqllogdisk" {
    name                            = "${azurerm_windows_virtual_machine.db.name}-sqllog" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 120
    tags                            = var.resource_tags
    #count                           = var.web_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "sqllogdisk_attach" {
    #count                           = var.web_node_count
    managed_disk_id                 = azurerm_managed_disk.sqllogdisk.id
    virtual_machine_id              = azurerm_windows_virtual_machine.db.id
    lun                             = 3
    caching                         = "ReadWrite"
}


# add a data disk SQL tempdb log
resource "azurerm_managed_disk" "sqltempdbdisk" {
    name                            = "${azurerm_windows_virtual_machine.db.name}-sqltempdbdisk" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 120
    tags                            = var.resource_tags
    #count                           = var.web_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "sqltempdbdisk_attach" {
    #count                           = var.web_node_count
    managed_disk_id                 = azurerm_managed_disk.sqltempdbdisk.id
    virtual_machine_id              = azurerm_windows_virtual_machine.db.id
    lun                             = 4
    caching                         = "ReadWrite"
}

# add a data disk SQL Backups
resource "azurerm_managed_disk" "sqlbackupdisk" {
    name                            = "${azurerm_windows_virtual_machine.db.name}-sqlbackupdisk" 
    location                        = azurerm_resource_group.rg.location
    resource_group_name             = azurerm_resource_group.rg.name
    storage_account_type            = "Premium_LRS"
 #   zones                          = [var.instancezone]
    create_option                   = "Empty"
    disk_size_gb                    = 120
    tags                            = var.resource_tags
    #count                           = var.web_node_count
}

resource "azurerm_virtual_machine_data_disk_attachment" "sqlbackupdisk_attach" {
    #count                           = var.web_node_count
    managed_disk_id                 = azurerm_managed_disk.sqlbackupdisk.id
    virtual_machine_id              = azurerm_windows_virtual_machine.db.id
    lun                             = 5
    caching                         = "ReadWrite"
}




################  Resource Group IAM Assignment
resource "azurerm_role_assignment" "emp1" {
  scope                =azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = "0becca84-f824-4032-9185-9d4c9bbf3475"
  # Mike Malake SID
}

resource "azurerm_role_assignment" "emp2" {
  scope                =azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = "9b238e45-330b-41dc-b577-f9cf743431bf"
  #Tony Burger SID
}

resource "azurerm_role_assignment" "emp3" {
  scope                =azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = "4c9cbda9-a1a0-41e0-8f1d-99c8f39094c2"
  # Irina Berdichevsky - sID 
}



