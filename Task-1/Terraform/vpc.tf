resource "aws_vpc" "main" {
  cidr_block       = "150.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "capstone-project-Sara"
    "kubernetes.io/cluster/sara-eks-301" = "shared"
    Owner                                 = "Saravana"
    Environment                           = "Course Project"
  }
}

resource "aws_subnet" "subnet-public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "150.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
    "kubernetes.io/cluster/sara-eks-301" = "shared"
    "kubernetes.io/role/elb"              = "1"
    Type                                  = "public-subnets"
  }
}

resource "aws_subnet" "subnet-public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "150.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
    "kubernetes.io/cluster/sara-eks-301" = "shared"
    "kubernetes.io/role/elb"              = "1"
    Type                                  = "public-subnets"
  }
}

resource "aws_subnet" "subnet-private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "150.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
    "kubernetes.io/cluster/sara-eks-301" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
    Type                                  = "private-subnets"
  }
}

resource "aws_subnet" "subnet-private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "150.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
    "kubernetes.io/cluster/sara-eks-301" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
    Type                                  = "private-subnets"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "capstone-project-igw"
  }
}

resource "aws_eip" "main" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id = aws_subnet.subnet-public1.id

  tags = {
    Name = "capstone-project-nat-gw"
  }
}

resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# associate route table to public subnet
resource "aws_route_table_association" "associate_routetable_to_public_subnet_1" {
  subnet_id      = aws_subnet.subnet-public1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "associate_routetable_to_public_subnet_2" {
  subnet_id      = aws_subnet.subnet-public2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# associate route table to private subnet
resource "aws_route_table_association" "associate_routetable_to_private_subnet_1" {
  subnet_id      = aws_subnet.subnet-private1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "associate_routetable_to_private_subnet_2" {
  subnet_id      = aws_subnet.subnet-private2.id
  route_table_id = aws_route_table.private_route_table.id
}