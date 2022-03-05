module "vpc" {
  source = "../../modules/vpc"
}

module "db" {
  source = "../../modules/db"
}

resource "aws_instance" "webserver" {
	ami = var.ami_app
	instance_type = "t2.micro"
	key_name = var.ssh_key
	subnet_id = module.vpc.public_subnet_id
    vpc_security_group_ids = [module.vpc.security_group_app_id]
    associate_public_ip_address = true

	user_data = <<EOF
  #!/bin/bash
  sudo apt update
  
  EOF
    
    # provisioner "file" {
    #     source      = "/FlaskMovieDB"
    #     destination = "~/"
    # } 

    # provisioner "local-exec" {
    #     inline = [
    #       "sudo apt update",
    #       "sudo apt install pip", 
    #       "sudo pip install #flask + dependencies",
    #       "sudo export MYSQL_USER=root",
    #       "sudo export MYSQL_PASSWORD=admin123",
    #       "sudo export MYSQL_DATABASE=root",
    #       "sudo export MYSQL_HOSTNAME=flask-app-db",
    #       "sudo export MYSQL_PORT=3306",
    #       "sudo python3 /FlaskMovieDB/application/app.py"
    #     ]

    # }
  
}


