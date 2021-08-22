provider "azurerm" {
    version = 1.38
    }

resource "azurerm_app_service_plan" "svcplan" {
  name                = "my-web-plan-8222021"               #unique name
  location            = var.region
  resource_group_name = var.ResourceGroup

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appsvc" {
  name                = "my-web-app-8222021"  #unique name
  location            = "eastus"
  resource_group_name = "Enter Resource Group Name"
  app_service_plan_id = azurerm_app_service_plan.svcplan.id


  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}