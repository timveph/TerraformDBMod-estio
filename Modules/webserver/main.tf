resource "aws_instance" "ansible" {
	ami = var.ami_app
	instance_type = "t2.micro"
	key_name = var.ssh_key
	subnet_id = aws_subnet.subpublic.id
    vpc_security_group_ids = [aws_security_group.sgapp.id]
    associate_public_ip_address = true
}


