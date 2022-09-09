resource "aws_vpc" "eks-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "eks-vpc"
  }
}

resource "aws_subnet" "eks-vpc-public-subnet-1a" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = "10.0.0.0/23"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    "Name"                       = "eks-vpc-public-subnet-1a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_subnet" "eks-vpc-public-subnet-1b" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = "10.0.64.0/23"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"

  tags = {
    "Name"                       = "eks-vpc-public-subnet-1b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_subnet" "eks-vpc-private-subnet-1a" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.2.0/23"
  availability_zone = "ap-south-1a"

  tags = {
    "Name"                            = "eks-vpc-private-subnet-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "eks-vpc-private-subnet-1b" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.32.0/23"
  availability_zone = "ap-south-1b"

  tags = {
    "Name"                            = "eks-vpc-private-subnet-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "NAT Gateway EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks-vpc-public-subnet-1a.id

  tags = {
    Name = "Main NAT Gateway"
  }
}

resource "aws_route_table" "public-1a" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table-1a"
  }
}

resource "aws_route_table" "public-1b" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table-1b"
  }
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.eks-vpc-public-subnet-1a.id
  route_table_id = aws_route_table.public-1a.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.eks-vpc-public-subnet-1b.id
  route_table_id = aws_route_table.public-1b.id
}

resource "aws_route_table" "private-1a" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table-1a"
  }
}

resource "aws_route_table" "private-1b" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table-1b"
  }
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.eks-vpc-private-subnet-1a.id
  route_table_id = aws_route_table.private-1a.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.eks-vpc-private-subnet-1b.id
  route_table_id = aws_route_table.private-1b.id
}
