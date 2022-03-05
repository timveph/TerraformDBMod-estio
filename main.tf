provider "aws" {
  region = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module vpc {
    source = "./modules/vpc"

}

module db {
    source = "./modules/db"

}

module "webserver" {  
    source = "./modules/webserver"

    
}
