variable "env" {
  description = "Environment being deployed (prod, uat, dev)"
  type = string
}

variable "subguid" {
  description = "Subscription GUID"
  type = string
}

variable "azure_location" {
  description = "Azure Location (Region) where the resources are to be deployed."
  type = string
}

variable "region" {
  description = "Region where the resources will be placed. This is the abbreviated version (i.e. WUS for West US)"
  type = string
}

#variable "avzones" {
#  description = "avzones available"
#  type = string
#}

variable "appabbrev" {
  description = "Three letter abbreviation for the application name."
  type = string
}

variable "web_node_count" {
  description = "How many web nodes to deploy."
  type = number
}

variable "app_node_count" {
  description = "How many app nodes to deploy."
  type = number
}

variable "resource_tags" {
  description = "Map value containing the resource tags."
  type = map
}

variable "azure_resource_group_name" {
  description = "Azure Resource Group Name where the resources are to be deployed"
  type = string
}

variable "bootdiags_primary_blob_endpoint" {
  description = "Blob Endpoint for the Storage Account used to store Boot Diagnostics"
  type = string
}

variable "azure_subnet_id" {
  description = "Azure Resoruce ID String identifying the Subnet where the resources will be deployed"
  type = string
}

variable "ad_vm_adminuserorgroup" {
  description = "Username or Group Name to be granted access to the VM via Active Directory (NAMCK)"
  type = string
  default = "s1wlc5a"
}

variable "local_vm_password" {
  description = "Password for the Local Admin User on the VM."
  type = string
}

variable "core_image_reference" {
  description = "Azure Resource Id of the image to use to build the VM. This typically points to the CORE CIS Hardened Image."
  type = string
}

variable "node_size" {
  description = "VM Size"
  type = string
}

variable "db_name" {
  description = "DB server name"
  type = string
}

variable "db_node_size" {
  description = "DB server name"
  type = string
}

variable "custom_image_resource_group_name" {
  description = "The name of the Resource Group in which the Custom Image exists."
}
variable "custom_image_name" {
  description = "The name of the Custom Image to provision this Virtual Machine from."
}

















#variable "server_zones" { 
#  description = "server zones list in region"
#  type = list
#  default = [1,2,3] 
#}