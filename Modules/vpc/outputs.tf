output "security-group-id" {
    value = aws_security_group.sgdb.id
}

output "private-subnet-1" {
    value = aws_subnet.subprivate1.id
}

output "private-subnet-2" {
    value = aws_subnet.subprivate2.id
}