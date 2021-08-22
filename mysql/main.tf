
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

resource "azurerm_mysql_server" "example" {
  name                = "mysql-8222021"
  location            = var.region
  resource_group_name = var.ResourceGroup

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "mysqladminun"
  administrator_login_password = "Passw0rd!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_database" "example" {
  name                = "exampledb"
  resource_group_name = var.ResourceGroup
  server_name         = azurerm_mysql_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}