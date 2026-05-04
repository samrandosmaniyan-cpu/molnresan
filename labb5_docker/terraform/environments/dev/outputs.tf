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

output "summary" {
  description = "Sammanfattning av dev-miljön"
  value       = module.webstack.summary
}