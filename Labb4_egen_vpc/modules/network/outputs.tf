output "vpc_id" {
  description = "ID för VPC:n"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Lista med ID:n för publika subnät"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Lista med ID:n för privata subnät"
  value       = aws_subnet.private[*].id
}

output "db_subnet_group_name" {
  description = "Namnet på DB subnet group"
  value       = aws_db_subnet_group.main.name
}

output "internet_gateway_id" {
  description = "ID för Internet Gateway"
  value       = aws_internet_gateway.main.id
}