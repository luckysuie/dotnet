terraform {
  backend "azurerm" {
    resource_group_name  = "lucky"
    storage_account_name = "luckystorage1234"
    container_name       = "appcontainer"
    key                  = "terraform.tfstate"
  }
}  