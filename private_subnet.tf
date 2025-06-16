resource "aws_subnet" "private_subnet" {
  count = length(local.availability_zones)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.72.${count.index + 11}.0/24"
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "My_private_subnet-${local.availability_zones[count.index]}"
  }
}

resource "aws_eip" "nat_gateway_eip" {
  count  = length(local.availability_zones)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(local.availability_zones)

  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    "Name" = "My_NatGateway-${local.availability_zones[count.index]}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = length(local.availability_zones)

  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table" "private_route_table" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "My_Private_Route_Table-${local.availability_zones[count.index]}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(local.availability_zones)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

