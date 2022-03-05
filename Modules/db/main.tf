module "vpc" {
  source = "../../modules/vpc"
}

resource  "aws_db_instance" "db" {


identifier = var.dbname

  engine            = var.mysql
  engine_version    = var.version5
  instance_class    = var.t2micro
  allocated_storage = 1

  db_name  = var.dbname
  username = var.user          
  password = var.pass
  port     = var.sqlport

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.vpc.security_group_id]
  
  tags = {
    Name = "default"
  }

  

}

# DB subnet group
 resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [module.vpc.private_subnet_1, module.vpc.private_subnet_2] #"${aws_subnet.subprivate2.id}"]

  tags = {
    Name = "My DB subnet group"
  }   
 }
 
