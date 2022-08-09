provider "aws" {
  region = "us-east-1"
}

#Creating the VPC:
resource "aws_vpc" "main" {
  cidr_block       = "192.169.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "My-VPC"
 }
}

#Creating the Public Subnet:
resource "aws_subnet" "PublicSub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.169.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "PublicSub"
  }
}

#Creating the Private Subnet:
resource "aws_subnet" "PrivateSub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.169.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "PrivateSub"
  }
}

#Creating the Internet Gateway:
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet-GateWay"
  }
}

#Creating the Routing Tables
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.PublicSub.id
  route_table_id = aws_route_table.rt.id
}

#Creating an Elastic Ip:
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

#Creating NAT Gateway:
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.PublicSub.id
  tags = {
    Name = "NAT-GatWay"
  }
}

resource "aws_route_table" "nat_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "NAT_routeTable"
  }
}

#Associating a Route Table to NAT Gateway:
resource "aws_route_table_association" "nat_asso" {
  subnet_id      = aws_subnet.PrivateSub.id
  route_table_id = aws_route_table.nat_route.id
}

#Creating the Security Group for MySQL:
resource "aws_security_group" "allow_mysql" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_mysql"
  }
}

#Launching the MySQL instance:
resource "aws_instance" "mysql" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.allow_mysql.id ]
  subnet_id = aws_subnet.PrivateSub.id
  user_data = <<-EOF
        
        #!/bin/bash
        sudo docker run -dit -p 8080:3306 --name mysql -e MYSQL_ROOT_PASSWORD=awscloud -e MYSQL_DATABASE=task-db -e MYSQL_USER=fares -e MYSQL_PASSWORD=fares mysql:5.7
  
  EOF

  tags = {
    Name = "allow_Mysql"
  }
}

#Creating the Security Group for WordPress:
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow tcp for inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "TLS from VPC"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_wp"
  }
}

#Launching the WordPress instance:
resource  "aws_instance"  "wordpress" {
  ami                          = "ami-052efd3df9dad4825"
  instance_type                = "t2.micro"
  availability_zone            = "us-east-1a"
  subnet_id                    = aws_subnet.PublicSub.id
  vpc_security_group_ids       = [ aws_security_group.wordpress_sg.id ]
  associate_public_ip_address  = "true"
  
  user_data = <<-EOF
        #!/bin/bash
        sudo docker run -dit -p 8081:80 --name wp wordpress:5.1.1-php7.3-apache
  EOF
    
  tags = {
    Name = "wordpress"  
  }
}

