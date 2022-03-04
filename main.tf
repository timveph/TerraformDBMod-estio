provider "aws" {
  region = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module vpc {
    source = "../modules/vpc"
}

module db {
    source = "../modules/db"

}

module "webserver" {  
    source = "../modules/webserver"

    vpc_id     = data.aws_vpc.main.id  
    subnet_ids = data.aws_subnet_ids.main.ids
    
    provisioner "file" {
        source      = "/FlaskMovieDB"
        destination = "~/"
    } 

    provisioner "local-exec" {
        inline = [
          "sudo apt update",
          "sudo apt install pip", 
          "sudo pip install #flask + dependencies",
          "sudo export MYSQL_USER=root",
          "sudo export MYSQL_PASSWORD=admin123",
          "sudo export MYSQL_DATABASE=root",
          "sudo export MYSQL_HOSTNAME=flask-app-db",
          "sudo export MYSQL_PORT=3306"
          "sudo python3 /FlaskMovieDB/application/app.py"
        ]

    }

    
  #   user_data  = << EOF
  # #! /bin/bash
  # sudo apt update
  # sudo apt install pip 
  # sudo pip install #flask + dependencies
  # sudo export MYSQL_USER=root
  # sudo export MYSQL_PASSWORD=admin123
  # sudo export MYSQL_DATABASE=root
  # sudo export MYSQL_HOSTNAME=flask-app-db
  # sudo export MYSQL_PORT=3306
  # EOF
  
}
