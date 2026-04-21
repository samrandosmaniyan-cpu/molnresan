output "instance_public_ip" {
  description = "Publik IP-adress till dev-EC2"
  value       = module.webstack.instance_public_ip
}

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
  description = "Dev-miljöns sammanfattning"
  value       = module.webstack.summary
}