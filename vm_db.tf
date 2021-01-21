resource "azurerm_linux_virtual_machine" "vmDB" {
    name                  = "vmDB"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.rg_ex01_aula.name
    network_interface_ids = [azurerm_network_interface.nic_DB.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "vmDB"
    admin_username = "alfredo"
    admin_password = "@Alfredo2021"
    disable_password_authentication = false

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stDB.primary_blob_endpoint
    }

}