resource "azurerm_virtual_network" "vnet_ex01_aula" {
    name                = "vnet_ex01_aula"
    address_space       = ["10.80.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_ex01_aula.name
}

resource "azurerm_subnet" "subnet_ex01_aula" {
    name                 = "subnet_ex01_aula"
    resource_group_name  = azurerm_resource_group.rg_ex01_aula.name
    virtual_network_name = azurerm_virtual_network.vnet_ex01_aula.name
    address_prefixes       = ["10.80.2.0/24"]
}

resource "azurerm_public_ip" "publicip_ex01_aula" {
    name                         = "publicip_ex01_aula"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_ex01_aula.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "nsg_ex01_aula" {
    name                = "nsg_ex01_aula"
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

    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTP"
        priority                   = 1003
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}

resource "azurerm_network_interface" "nic_ex01_aula" {
    name                        = "nic_ex01_aula"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.rg_ex01_aula.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.subnet_ex01_aula.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.80.4.11"
        public_ip_address_id          = azurerm_public_ip.publicip_ex01_aula.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsga_ex01_aula" {
    network_interface_id      = azurerm_network_interface.nic_ex01_aula.id
    network_security_group_id = azurerm_network_security_group.nsg_ex01_aula.id
}


data "azurerm_public_ip" "data_azure_public_ip" {
    name = azurerm_public_ip.publicip_ex01_aula.name
    resource_group_name = azurerm_resource_group.rg_ex01_aula.name
}