# ============================================
# NETWORK OUTPUTS
# ============================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Publika subnät-IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Privata subnät-IDs"
  value       = module.network.private_subnet_ids
}

# ============================================
# WEBSTACK OUTPUTS
# ============================================

output "web_url" {
  description = "URL till dev-webbsidan"
  value       = module.webstack.web_url
}

output "ssh_command" {
  description = "SSH-kommando för att ansluta till dev"
  value       = "ssh -i ../../keys/dev-key ec2-user@${module.webstack.instance_public_ip}"
}

output "db_endpoint" {
  description = "Endpoint för dev-databasen"
  value       = module.webstack.db_endpoint
}

output "db_name" {
  description = "Namnet på dev-databasen"
  value       = module.webstack.db_name
}

output "summary" {
  description = "Sammanfattning av dev-miljön"
  value       = module.webstack.summary
}