
 
 
 resource "db" {


identifier = var.dbname

#   engine            = "mysql" var
#   engine_version    = "5.7.25"
#   instance_class    = "db.t2.micro"
#   allocated_storage = 1

#   db_name  = "demodb"
#   username = "user"          var
#   password = "password"
#   port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids =//var ["sg-12345678"] tags = {
    # Owner       =//var "user"
    # Environment =//var "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             =// var.subnet_ids ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family =//var "mysql5.7"
 }
