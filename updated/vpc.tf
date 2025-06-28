resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    "Name" = "My_VPC"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "Main_IGW"
  }
}

resource "aws_eip" "ngw_eip" {
  for_each = aws_subnet.public_subnet

  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  for_each = aws_subnet.public_subnet

  allocation_id = aws_eip.ngw_eip[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id
}

resource "aws_route_table" "rt_private" {
  for_each = aws_subnet.public_subnet

  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
  }
}
resource "aws_route_table_association" "rta_private" {
  for_each = aws_subnet.private_subnet

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.rt_private[each.key].id
}
