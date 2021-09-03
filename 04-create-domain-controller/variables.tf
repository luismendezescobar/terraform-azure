variable "prefix" {
  default="luis82"
  description = "The prefix used for all resources in this example. Needs to be a short (6 characters) alphanumeric string. Example: `myprefix`."
}

variable "admin_username" {
  default="luis"
  description = "The username of the administrator account for both the local accounts, and Active Directory accounts. Example: `myexampleadmin`"
}

variable "admin_password" {
  default="Passw0rd1234!"
  description = "The password of the administrator account for both the local accounts, and Active Directory accounts. Needs to comply with the Windows Password Policy. Example: `PassW0rd1234!`"
}


variable "resource_group"{
  default="1-c3311de9-playground-sandbox"  #this variable has to be modified everytime that you execute this repo from scratch, that's it
  description = "update the resource group here"
}