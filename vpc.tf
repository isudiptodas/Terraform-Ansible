resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { 
     Name = "new-vpc"
  }
}

resource "aws_internet_gateway" "new-itg" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "new-internet-gateway"
  }
}

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

resource "aws_subnet" "public-subnet" {
  count = 3
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "new-association" {
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.new-route-table.id
}
