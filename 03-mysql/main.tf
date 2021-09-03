
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
  
  administrator_login          = "mysqladminun"
  administrator_login_password = "Passw0rd!"

  sku_name = "B_Gen5_2"
  storage_mb = 5120
  version="5.7"
  
  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
  
}

resource "azurerm_mysql_database" "example" {
  name                = "exampledb"
  resource_group_name = var.ResourceGroup
  server_name         = azurerm_mysql_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}