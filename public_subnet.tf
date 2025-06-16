#Public Subnet configuration block
resource "aws_subnet" "public_subnet" {
  count             = length(local.availability_zones)
  availability_zone = local.availability_zones[count.index]

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.72.${count.index + 1}.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "My_public_subnet-${local.availability_zones[count.index]}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "internet-gateway-My_VPC"
  }
}
resource "aws_route_table" "public_route_table" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    "Name" = "public_route_table-${local.availability_zones[count.index]}"
  }
}
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(local.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}