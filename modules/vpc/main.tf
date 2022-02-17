data "aws_availability_zones" "available" {}
#Create VPC
resource "aws_vpc" "carlos" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "carlos-ecs-vpc"

    }
}
#Create public subnets
resource "aws_subnet" "pub" {
  count = 3
  vpc_id = aws_vpc.carlos.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "carlos-tf-pub${count.index}-subnet"

  }
}
#Create private subnets
resource "aws_subnet" "priv" {
  count = 3
  vpc_id = aws_vpc.carlos.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index+3)
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "carlos-tf-priv${count.index}-subnet"

  }
}
#Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.carlos.id
  tags = {
    Name = "carlos-tf-igw"
  }
}
#Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "carlos-tf-NAT-GW-EIP"
  }
}
#Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.pub[1].id

  tags = {
    Name = "carlos-tf-NAT-GW"
  }
  depends_on = [aws_internet_gateway.igw]
}
#Create Public Route Table
resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.carlos.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
  tags = {
    Name = "carlos-tf-pubRT"
  }
}
#Create Private Route Table
resource "aws_route_table" "privRT" {
  vpc_id = aws_vpc.carlos.id
  
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "carlos-tf-privRT"
  }
}
#Associate the Public Route Table
resource "aws_route_table_association" "pub" {
  count = 3
  subnet_id = aws_subnet.pub[count.index].id 
  route_table_id = aws_route_table.pubRT.id 
}
#Associate the Private Route Table
resource "aws_route_table_association" "priv" {
  count = 3
  subnet_id = aws_subnet.priv[count.index].id 
  route_table_id = aws_route_table.privRT.id 
}