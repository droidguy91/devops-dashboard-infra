/**
VPC: Creates a virtual network with the CIDR block 10.0.0.0/16.
Public Subnet: A subnet for EC2 instances that need internet access, using the 10.0.1.0/24 CIDR block.
Private Subnet: A subnet for EC2 instances that don't require direct internet access, using the 10.0.2.0/24 CIDR block.
Internet Gateway: Allows internet access for the public subnet.
Route Table: Defines routing between the public subnet and the internet gateway.
 */

# VPC configuration for EKS
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # CIDR block for the VPC
  enable_dns_support = true  # Enable DNS support within the VPC
  enable_dns_hostnames = true  # Enable DNS hostnames for instances in the VPC
  tags = {
    Name = "main-vpc"
  }
}

# Public subnet configuration
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.main.id  # VPC ID this subnet belongs to
  cidr_block              = "10.0.1.0/24"  # CIDR block for the public subnet
  map_public_ip_on_launch = true  # Automatically assign public IP to instances in this subnet
  availability_zone       = "us-west-2a"  # Availability zone for this subnet
  tags = {
    Name = "public-subnet"
  }
}

# Private subnet configuration
resource "aws_subnet" "subnet_private" {
  vpc_id                  = aws_vpc.main.id  # VPC ID this subnet belongs to
  cidr_block              = "10.0.2.0/24"  # CIDR block for the private subnet
  availability_zone       = "us-west-2b"  # Availability zone for this subnet
  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway for public subnet access to the internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id  # Attach the internet gateway to the VPC
}

# Route Table for public subnet
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id  # VPC ID for the route table
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_public.id  # Subnet ID to associate
  route_table_id = aws_route_table.rt.id  # Route table ID to associate
}
