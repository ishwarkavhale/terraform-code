
resource "aws_key_pair" "login_key" {
  key_name = "aws_prod_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

 tags = {
    Name = "aws-prod"
  }

}

resource "aws_subnet" "Public_subnet1" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true


  tags = {
    Name = "Public_subnet1"
  }
}
resource "aws_subnet" "Public_subnet2" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true


  tags = {
    Name = "Public_subnet2"
  }
}

resource "aws_subnet" "Private_subnet1" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false


  tags = {
    Name = "Private_subnet1"
  }
}

resource "aws_subnet" "Private_subnet2" {
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = "10.0.64.0/20"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false


  tags = {
    Name = "Private_subnet2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod_vpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pubass1" {
  subnet_id = aws_subnet.Public_subnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "pupass2" {
  subnet_id = aws_subnet.Public_subnet2.id
  route_table_id = aws_route_table.RT.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.Public_subnet1.id

  tags = {
    Name = "MyNATGateway"
  }
}

resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "PrivateRouteTable1"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "PrivateRouteTable2"
  }
}

resource "aws_route_table_association" "pvtass1" {
  subnet_id = aws_subnet.Private_subnet1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "pvtass2" {
  subnet_id = aws_subnet.Private_subnet2.id
  route_table_id = aws_route_table.private_route_table2.id
}


