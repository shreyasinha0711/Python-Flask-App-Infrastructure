/*
  Create VPC
*/
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"        = "main_vpc",
    "Environment" = "${var.environment_tag}"
  }
}

/*
  Create Internet Gateway
*/
resource "aws_internet_gateway" "main_igw" {
  depends_on = [
    aws_vpc.main_vpc,
  ]
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name"        = "main_igw",
    "Environment" = "${var.environment_tag}"
  }
}

/*
  Create Subnet Public
*/
resource "aws_subnet" "main_subnet_public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.cidr_subnet_public
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone_public
  tags = {
    "Name"        = "main_subnet_public",
    "Environment" = "${var.environment_tag}"
  }
}

/*
  Create Subnet Private
*/
resource "aws_subnet" "main_subnet_private" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.cidr_subnet_private
  availability_zone = var.availability_zone_private
  tags = {
    "Name"        = "main_subnet_private",
    "Environment" = "${var.environment_tag}"
  }
}

/*
  Create Route Table
*/
resource "aws_route_table" "main_rtb_public" {
  depends_on = [
    aws_vpc.main_vpc,
    aws_internet_gateway.main_igw,
  ]
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    "Name"        = "main_rtb_public",
    "Environment" = "${var.environment_tag}"
  }
}

/*
  Create Route Table Association with Subnet
*/
resource "aws_route_table_association" "main_rta_subnet_public" {
  depends_on = [
    aws_subnet.main_subnet_public,
    aws_route_table.main_rtb_public,
  ]
  subnet_id      = aws_subnet.main_subnet_public.id
  route_table_id = aws_route_table.main_rtb_public.id
}

/*
  Create Elastic IP
*/
resource "aws_eip" "main_elastic_ip" {
  vpc = true
}

/*
  Create NAT Gateway
*/
resource "aws_nat_gateway" "main_nat_gateway" {
  depends_on = [
    aws_subnet.main_subnet_public,
    aws_eip.main_elastic_ip,
  ]
  allocation_id = aws_eip.main_elastic_ip.id
  subnet_id     = aws_subnet.main_subnet_public.id

  tags = {
    Name          = "main_nat_gateway",
    "Environment" = "${var.environment_tag}"
  }
}

/*
 Create Route table with target as NAT gateway
*/
resource "aws_route_table" "main_rtb_nat" {
  depends_on = [
    aws_vpc.main_vpc,
    aws_nat_gateway.main_nat_gateway,
  ]

  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_nat_gateway.id
  }

  tags = {
    Name          = "main_rtb_nat",
    "Environment" = "${var.environment_tag}"
  }
}

/*
Create Associate route table to private subnet
*/
resource "aws_route_table_association" "main_rta_subnet_private" {
  depends_on = [
    aws_subnet.main_subnet_private,
    aws_route_table.main_rtb_nat
  ]
  subnet_id      = aws_subnet.main_subnet_private.id
  route_table_id = aws_route_table.main_rtb_nat.id
}
