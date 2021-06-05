terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/.aws/credentials"
}

resource "aws_instance" "myinstance" {
  ami               = "ami-09e67e426f25ce0d7"
  instance_type     = "t2.micro"
  key_name          = "keyname"
  availability_zone = "us-east-1a"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.mynic.id
  }

  tags = {
    Name = "Web-SERVER"
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "myvpc"
  }
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "mygw"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.mygw.id
  }

  tags = {
    Name = "my-RT"
  }
}

resource "aws_subnet" "mysub" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mysubnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysub.id
  route_table_id = aws_route_table.myrt.id
}


resource "aws_security_group" "myallow" {
  name        = "allow_ports"
  description = "Allow ports for traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ports"
  }
}

resource "aws_network_interface" "mynic" {
  subnet_id       = aws_subnet.mysub.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.myallow.id]
}

resource "aws_eip" "myeip" {
  vpc                       = true
  instance = aws_instance.myinstance.id
  network_interface         = aws_network_interface.mynic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.mygw]
}