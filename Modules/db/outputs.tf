output "db_endpoint" {
    value = aws_db_instance.db.endpoint
}

output "username" {
    value = aws_db_instance.db.username
}

output "password" {
    value = nonsensitive(aws_db_instance.db.password)
}            


output "db_name" {
    value = aws_db_instance.db.db_name
}

output "instance_name" {
    value = aws_db_instance.db.arn
}