resource "aws_vpc" "vpc" {
  cidr_block       = "192.72.0.0/16"
  instance_tenancy = "default"



  tags = {
    "Name" = "My_VPC"
  }
}





