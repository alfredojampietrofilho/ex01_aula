resource "null_resource" "deploy_db" {
    triggers = {
      order = azurerm_linux_virtual_machine.vmDB.id
    }
  
    provisioner "file" {

        connection {
            type    =   "ssh"
            user    =   "alfredo"
            password =  "@Alfredo2021"
            host    = data.azurerm_public_ip.data.azure.publicip_DB.ip_address
        }

        source      = "mysql"
        destination = "/home/azureuser"    
    }
}


resource "null_resource" "setup_database" {
    triggers = {
      order = null_resource.deploy_db.id
    }
  
    provisioner "remote-exec" {

        connection {
            type    =   "ssh"
            user    =   "alfredo"
            password =  "@Alfredo2021"
            host    = data.azurerm_public_ip.data.azurerm.publicip_DB.ip_address
        }

        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y mysql-server-5.7",
            "sudo mysql < /home/azureuser/mysql/script/user.sql",
            "sudo mysql < /home/azureuser/mysql/script/schema.sql",
            "sudo mysql < /home/azureuser/mysql/script/data.sql",
            "sudo cp -f /home/azureuser/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf",
            "sudo service mysql restart",
            "sleep 20",
        ]
    }
}