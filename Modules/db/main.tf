resource  "aws_db_instance" "db" {


identifier = "mydb"

  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = "phil"
  password             = "password"
  port                 = "3306"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  

  iam_database_authentication_enabled = false

  db_subnet_group_name = var.my_private_subnet_group

  vpc_security_group_ids = [var.my_security_group]

  tags = {
    Name = "estio"
  }

}




 
 
