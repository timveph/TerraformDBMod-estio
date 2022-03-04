resource "aws_vpc" "mainvpc" {
  cidr_block = var.vpccidr
  tags = {
    Name = "${var.name}.tf.vpc"
  }
}

# Create an igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "${var.name}.igw"
  }
}

# Create public sub
resource "aws_subnet" "subpublic" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.cidrsubpub
  availability_zone = var.AZa
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}.subpublic"
  }
}

# Create private sub
resource "aws_subnet" "subprivate" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.cidrsubpr1
  availability_zone = var.AZb
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}.subprivate1"
  }
}

# Create private sub
resource "aws_subnet" "subprivate2" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.cidrsubpr2
  availability_zone = var.AZc
  map_public_ip_on_launch = false 

  tags = {
    Name = "${var.name}.subprivate2"
  }
}

# Creating a public route table
resource "aws_route_table" "routepublic" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = var.opencidr
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.name}.route.public"
  }
}

# Creating a private route table
resource "aws_route_table" "routepublic" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "10.0.0.0/16" #var
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.name}.route.public"
  }
}

# Route table associations
resource "aws_route_table_association" "routeapp" {
  subnet_id = aws_subnet.subpublic.id
  route_table_id = aws_route_table.routepublic.id
}

resource "aws_route_table_association" "routedb" {
  subnet_ids = [aws_subnet.subprivate1.id, aws_subnet.subprivate1.id]
  route_table_id = aws_route_table.routeprivate.id
}

# Creating security group for webapp
resource "aws_security_group" "sgapp" {
  name        = "app-sg" #var
  description = "Allow http and https traffic" #var
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
   description = "httpx from VPC" #var
   from_port = 443 
   to_port = 443 
   protocol = "tcp" #var
   cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
   description = "httpx from VPC"
   from_port = 80 
   to_port = 80 
   protocol = "tcp" 
   cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
   description = "ssh"
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
   to_port = 0 
   from_port = 0
   protocol = -1 
   cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}sg.app"
  }
}

resource "aws_security_group" "sgdb" {
  name        = "db-sg" #var
  description = "Allow only EC2 access" #var
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
   description = "httpx from VPC" #var
   from_port = 443 
   to_port = 443 
   protocol = "tcp" #var
   security_groups = [aws_security_group.sgapp.id]
  }
