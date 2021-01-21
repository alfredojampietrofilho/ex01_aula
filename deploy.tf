resource "null_resource" "deploy_app" {
    triggers = {
      order = azurerm_linux_virtual_machine.vmex01aula.id
    }
  
    provisioner "file" {

        connection {
            type    =   "ssh"
            user    =   "alfredo"
            password =  "@Alfredo2021"
            host    = data.azurerm_public_ip.data_azure_public_ip.ip_address
        }

        source      = "springapp"
        destination = "/home/azureuser"    
    }
}


resource "null_resource" "setup_app" {
    triggers = {
      order = null_resource.deploy_app.id
    }
  
    provisioner "remote-exec" {

        connection {
            type    =   "ssh"
            user    =   "alfredo"
            password =  "@Alfredo2021"
            host    = data.azurerm_public_ip.data_azure_public_ip.ip_address
        }

        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y openjdk-11-jre unzip",
            "mkdir /home/azureuser/springmvcapp",
            "rm -rf /home/azureuser/springmvcapp/*.*",
            "unzip -o /home/azureuser/springapp/springapp.zip -d /home/azureuser/springmvcapp",
            "nohup java -Dspring.profiles.active=mysql -jar /home/azureuser/springmvcapp/*.jar &",
            "sleep 20",
        ]

    }
}