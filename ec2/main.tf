provider "aws" {
  region = var.aws
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_internet_gateway.id
  }
}

resource "aws_route_table_association" "route_public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_security_group" "security_group_inbound" {
  description = "Allow inbound Traffic"
  vpc_id = aws_vpc.my_vpc.id
   ingress {
    description = "http inbound traffic from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
     ingress {
    description = "https inbound traffic from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh inbound"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_server" {
  ami = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  key_name = "test"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.security_group_inbound.id]
}
resource "aws_eip" "elastic_ip_nat" {
  domain = "vpc"
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
}

resource "aws_route_table_association" "route_private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id

}

resource "aws_nat_gateway" "nat-gateway" {
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.elastic_ip_nat.id
}

resource "aws_instance" "ec2" {
  ami = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  key_name = "test"
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.security_group_inbound.id]
}



# resource "aws_instance" "ec2" {
#     ami = var.ec2_instance.ami
#   instance_type = var.ec2_instance.instance_type
#   key_name = var.ec2_instance.key_name
#    tags = {
#         Name = "ec2-instance"
#    }
   
# }
