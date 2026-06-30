# ========================================VPC========================================
resource "aws_vpc" "main" {
  
  cidr_block = var.vpc_cidr
  tags = {
    Name = "entryTracker-vpc"
  }
}
# ========================================igw========================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "entryTracker-igw"
  }
}

# ========================================public-route-table========================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
# ========================================Subnets========================================
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "public-subnet"
  }
  
}
# ========================================Route Table Association========================================
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
