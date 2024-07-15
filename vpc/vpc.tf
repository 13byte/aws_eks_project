# VPC
resource "aws_vpc" "default" {
  cidr_block           = "10.${var.cidr_numeral}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "ngw" {
  count         = length(var.availability_zones)
  allocation_id = element(aws_eip.ngw.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "nat-gw-${var.vpc_name}-${element(var.short_azs, count.index)}"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "ngw" {
  count  = length(var.availability_zones)
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name    = "public-${var.vpc_name}-${element(var.short_azs, count.index)}"
    Network = "public"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "public-rt-${element(var.short_azs, count.index)}-${var.vpc_name}"
    Network = "public"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

# Private WAS Subnets
resource "aws_subnet" "private_was" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private_was[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch                     = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name    = "private-was-${var.vpc_name}-${element(var.short_azs, count.index)}"
    Network = "private"
  }
}

# Route Table for Private WAS Subnets
resource "aws_route_table" "private_was" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "private-was-rt-${var.vpc_name}-${element(var.short_azs, count.index)}"
    Network = "private"
  }
}

# Route Table Association for Private WAS
resource "aws_route_table_association" "private_was" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private_was.*.id, count.index)
  route_table_id = element(aws_route_table.private_was.*.id, count.index)
}

# Private DB Subnets
resource "aws_subnet" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private_db[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch                     = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name    = "private-db-${var.vpc_name}-${element(var.short_azs, count.index)}"
    Network = "private"
  }
}

# Route Table for Private DB Subnets
resource "aws_route_table" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "private-db-rt-${var.vpc_name}-${element(var.short_azs, count.index)}"
    Network = "private"
  }
}

# Route Table Association for Private DB
resource "aws_route_table_association" "private_db" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = element(aws_route_table.private_db.*.id, count.index)
}
