output "public_sunet_ids" {
  value = [for s in aws_subnet.public_subnet : s.id]
}
output "private_subnet_ids" {
  value = [for p in aws_subnet.private_subnet : p.id]
}
