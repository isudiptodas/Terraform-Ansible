
# new VPC
resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { 
     Name = "new-vpc"
  }
}

# internet gateway under a new VPC
resource "aws_internet_gateway" "new-itg" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "new-internet-gateway"
  }
}

# route table under a new VPC with routes
resource "aws_route_table" "new-route-table" {
  vpc_id = aws_vpc.new-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new-itg.id
  }
  route {
    cidr_block = aws_vpc.new-vpc.cidr_block
    gateway_id = "local"
  }
  tags = {
    Name = "new-route-table"
  }
}

# subnets under VPC
resource "aws_subnet" "public-subnet" {
  count = 3
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# connecting route tables with subnets
resource "aws_route_table_association" "new-association" {
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.new-route-table.id
}
