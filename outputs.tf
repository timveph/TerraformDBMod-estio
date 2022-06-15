output "database_endpoint" {
    value = module.db.db_endpoint
}

output "public_ip" {
    value = module.webserver.public_ip_ad
}