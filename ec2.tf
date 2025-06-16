resource "aws_instance" "private_instance" {
  count                       = length(local.availability_zones)
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet[count.index].id
  key_name                    = aws_key_pair.bastion_host_key_pair.key_name
  associate_public_ip_address = false

  tags = {
    Name = "PrivateInstance-${count.index}"
  }

  vpc_security_group_ids = [aws_security_group.private_sg.id]
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSG"
  }
}
