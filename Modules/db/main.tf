
 
 
 resource  "aws_db_instance" "db" {


identifier = var.dbname

  engine            = var.mysql
  engine_version    = var.version
  instance_class    = var.t2micro
  allocated_storage = 1

  db_name  = var.dbname
  username = var.user          
  password = var.pass
  port     = var.sqlport

  iam_database_authentication_enabled = false

  vpc_security_group_ids = var.idsg 
  tags = {
    
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.subnetids 

  # DB parameter group
  family = var.family 
 }
