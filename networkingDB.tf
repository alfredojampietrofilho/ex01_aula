resource "azurerm_virtual_network" "vnet_DB" {
    name                = "vnet_DB"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_ex01_aula.name
}

resource "azurerm_subnet" "subnet_DB" {
    name                 = "subnet_DB"
    resource_group_name  = azurerm_resource_group.rg_ex01_aula.name
    virtual_network_name = azurerm_virtual_network.vnet_ex01_aula.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "publicip_db" {
    name                         = "publicip_db"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_ex01_aula.name
    allocation_method            = "Static"
}

resource "azurerm_network_security_group" "nsg_DB" {
    name                = "nsg_DB"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_ex01_aula.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "nic_DB" {
    name                        = "nic_DB"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.rg_ex01_aula.name

    ip_configuration {
        name                          = "myNicConfigurationDB"
        subnet_id                     = azurerm_subnet.subnet_ex01_aula.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.80.4.10"
        public_ip_address_id          = azurerm_public_ip.publicip_db.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsga_DB" {
    network_interface_id      = azurerm_network_interface.nic_DB.id
    network_security_group_id = azurerm_network_security_group.nsg_ex01_aula.id
}

data "azurerm_public_ip" "data_azure_public_ip_db" {
    name = azurerm_public_ip.publicip_db.name
    resource_group_name = azurerm_resource_group.rg_ex01_aula.name
}
