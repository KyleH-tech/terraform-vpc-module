resource "aws_instance" "bastion_host" {

  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_host_key_pair.key_name

  tags = {
    "Name" = "Bastion_Host"
  }

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
}
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #update the cidr_blocks argument with either your pulic IP or 0.0.0.0/0 to allow all traffic 
    cidr_blocks = [var.ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Bastion_Host_SG"
  }
}


output "bastion_host_ip" {
  value       = aws_instance.bastion_host.public_ip
  description = "Used for ssh into public bastion host instance"
}
