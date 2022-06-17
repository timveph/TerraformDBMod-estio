variable "ami_app" {
    type = string
    default = "ami-073ee45c9f61cbaa3"
}

variable "ssh_key" {
    type = string
    default = "myKey"
}

variable "my_security_group_id" {
    type = string
    default = ""
}

variable "my_subnet_id" {
    type = string
    default = ""
}


variable "get_public_ip" {
    type = string
}

variable "get_db_endpoint" {
    type = string
    default = ""
}

variable "username" {
    type = string
    default = ""
}

variable "password" {
    type = string
    default = ""
}            


variable "db_name" {
    type = string
    default = ""
}

variable "database_instance" {
    type = string
    default = ""
}

variable "vpc_id" {
    type = string
    default = ""
}
