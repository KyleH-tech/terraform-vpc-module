resource "aws_subnet" "public_subnet" {
  for_each = toset(var.azs)

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(var.azs, each.value))
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Public-Subnet-${each.value}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = toset(var.azs)

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(var.azs, each.value) + length(var.azs))
  availability_zone       = each.value
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private-Subnet-${each.value}"
  }
}
