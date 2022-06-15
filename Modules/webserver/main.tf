resource "aws_instance" "webserver" {
	ami = var.ami_app
	instance_type = "t2.micro"
	key_name = var.ssh_key
	associate_public_ip_address = true
	private_ip = "10.0.1.10"
	subnet_id = var.my_subnet_id
	security_groups = [var.my_security_group_id]
  user_data = "${file("script.sh")}"

}

resource "null_resource" "connect_web" {
  provisioner "remote-exec" {
    inline = [
      "sudo echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"
    ]
    connection {
      host        = aws_instance.webserver.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./myKey")
    }

   }
  depends_on = [aws_instance.webserver]
}

resource "null_resource" "cluster" {


  connection {
      host        = aws_instance.webserver.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./myKey")
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install mysql-server -y",
      "git clone https://github.com/nathanforester/FlaskMovieDB2.git"
    ]
  }
}
