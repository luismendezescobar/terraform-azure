
terraform {
  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "hashicorp/azurerm"
      version = "~> 2.12"

   
    }
  }
}

provider "azurerm" {
  features {}
  #subscription_id="4cedc5dd-e3ad-468d-bf66-32e31bdb9148"
  skip_provider_registration = "true"
      
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
  location            = var.region
  resource_group_name = var.ResourceGroup
  app_service_plan_id = azurerm_app_service_plan.svcplan.id


  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}


