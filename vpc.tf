provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  enable_classiclink = "false"
  tags = {
      Name = "dev"
  }
}


resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
      "Name" = "dev-public-1"
    }
}



resource "aws_internet_gateway" "dev-igw" {
   vpc_id = aws_vpc.myvpc.id
   tags = {
    "Name" = "dev"
   }
}


resource "aws_route_table" "dev-rt" {
     vpc_id = aws_vpc.myvpc.id
     route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.dev-igw.id

     }
     tags = {
        "Name" = "dev-rt"
     }
}
resource "aws_route_table_association" "subnet1rt" {
     subnet_id = aws_subnet.subnet1.id  
     route_table_id = aws_route_table.dev-rt.id
}