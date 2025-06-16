resource "tls_private_key" "bastion_host_key" {
  rsa_bits  = 4096
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion_host_key_pair" {
  key_name   = "terraform_generated_key"
  public_key = tls_private_key.bastion_host_key.public_key_openssh
  tags = {
    "Name" = "Terraform Generated Key"
  }
}

output "private_key_pem" {
  value = tls_private_key.bastion_host_key.private_key_pem
}

output "key_name" {
  value = aws_key_pair.bastion_host_key_pair.key_name
}