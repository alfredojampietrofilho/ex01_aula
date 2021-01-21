resource "azurerm_storage_account" "stDB" {
    name                        = "stDB"
    resource_group_name         = azurerm_resource_group.rg_ex01_aula.name
    location                    = "eastus"
    account_replication_type    = "LRS"
    account_tier                = "Standard"
}