resource "aws_instance" "webserver" {
	ami = var.ami_app
	instance_type = "t2.micro"
	key_name = var.ssh_key
	associate_public_ip_address = true
	private_ip = "10.0.1.10"
	subnet_id = var.my_subnet_id
	security_groups = [var.my_security_group_id]
  user_data = <<-EOL
  #!/bin/bash 
  sudo apt-get update -y
  sudo echo "USERNAME=${var.username}" >> /etc/environment
  sudo echo "PASSWORD=${var.password}" >> /etc/environment
  sudo echo "ENDPOINT=${var.get_db_endpoint}" >> /etc/environment
  sudo echo "NAME=${var.db_name}" >> /etc/environment
  EOL
  tags = {
    Name = "estio"
  }
  depends_on = [var.database_instance]
  
}

resource "null_resource" "connect_web" {
  provisioner "remote-exec" {
    inline = [
      "sudo echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"
    ]
    connection {
      host        = aws_instance.webserver.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./myPrivateKey")
    }

   }
  depends_on = [aws_instance.webserver]
}

resource "null_resource" "file_transfer" {
    provisioner "file" {
        source = "./ansible-project"
        destination = "/home/ubuntu/"

        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("myPrivateKey")}"
            host        = aws_instance.webserver.public_ip
        }
    }

    depends_on = [
        aws_instance.webserver, null_resource.connect_web
    ] 
    
}

resource "null_resource" "connect_web2" {
  provisioner "remote-exec" {
    inline = [
      "sudo su -l ubuntu -c 'sudo apt-get update -y'",
      "sudo su -l ubuntu -c 'sudo apt-get upgrade --fix-missing -y'",
      "sudo su -l ubuntu -c 'sudo git clone https://github.com/timveph/FlaskMovieDB2-estio.git'",
      "sudo su -l ubuntu -c 'sudo chown ubuntu -R /home/ubuntu/FlaskMovieDB2-estio/'", #chown: missing operand after ‘/home/ubuntu/FlaskMovieDB2’
      "sudo su -l ubuntu -c 'sudo chown ubuntu /home/ubuntu/FlaskMovieDB2-estio/startup.sh /home/ubuntu/FlaskMovieDB2-estio/create.py /home/ubuntu/FlaskMovieDB2-estio/app.py'",
      "sudo su -l ubuntu -c 'sudo apt-get install mysql-client-core-8.0 -y'",
      "sudo su -l ubuntu -c 'sudo apt-get install ansible -y'", 
      # "sudo su -l ubuntu -c 'sudo add-apt-repository --yes --update ppa:ansible/ansible'",
      "sudo su -l ubuntu -c 'ansible-playbook /home/ubuntu/ansible-project/playbook.yaml'",
      "sudo su -l ubuntu -c 'sudo chown ubuntu /var/run/docker.sock'",
      "sudo su -l ubuntu -c '. /home/ubuntu/FlaskMovieDB2-estio/startup.sh'",
     ]

# module.webserver.null_resource.connect_web2 (remote-exec): Err:2 http://security.ubuntu.com/ubuntu focal-updates/main amd64 mysql-client-core-8.0 amd64 8.0.29-0ubuntu0.20.04.3
# module.webserver.null_resource.connect_web2 (remote-exec):   404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): 
# module.webserver.null_resource.connect_web2 (remote-exec): Err:3 http://security.ubuntu.com/ubuntu focal-updates/main amd64 mysql-client-8.0 amd64 8.0.29-0ubuntu0.20.04.3
# module.webserver.null_resource.connect_web2 (remote-exec):   404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): 
# module.webserver.null_resource.connect_web2 (remote-exec): Err:7 http://security.ubuntu.com/ubuntu focal-updates/main amd64 mysql-server-core-8.0 amd64 8.0.29-0ubuntu0.20.04.3
# module.webserver.null_resource.connect_web2 (remote-exec):   404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): 
# module.webserver.null_resource.connect_web2 (remote-exec): Err:8 http://security.ubuntu.com/ubuntu focal-updates/main amd64 mysql-server-8.0 amd64 8.0.29-0ubuntu0.20.04.3
# module.webserver.null_resource.connect_web2 (remote-exec):   404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): 
# module.webserver.null_resource.connect_web2 (remote-exec): E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/mysql-client-core-8.0_8.0.29-0ubuntu0.20.04.3_amd64.deb  404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/mysql-client-8.0_8.0.29-0ubuntu0.20.04.3_amd64.deb  404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/mysql-server-core-8.0_8.0.29-0ubuntu0.20.04.3_amd64.deb  404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/mysql-server-8.0_8.0.29-0ubuntu0.20.04.3_amd64.deb  404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/mysql-server_8.0.29-0ubuntu0.20.04.3_all.deb  404  Not Found [IP: 91.189.91.38 80]
# module.webserver.null_resource.connect_web2 (remote-exec): E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
     
    connection {
      host        = aws_instance.webserver.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./myPrivateKey")
    }

   }
  depends_on = [aws_instance.webserver, null_resource.connect_web, null_resource.file_transfer]
}
