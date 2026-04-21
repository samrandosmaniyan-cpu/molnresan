output "instance_public_ip" {
  description = "Publik IP-adress till prod-EC2"
  value       = module.webstack.instance_public_ip
}

output "web_url" {
  description = "URL till prod-webbsidan"
  value       = module.webstack.web_url
}

output "ssh_command" {
  description = "SSH-kommando för att ansluta till prod"
  value       = "ssh -i ../../keys/prod-key ec2-user@${module.webstack.instance_public_ip}"
}

output "db_endpoint" {
  description = "Endpoint för prod-databasen"
  value       = module.webstack.db_endpoint
}

output "db_name" {
  description = "Namnet på prod-databasen"
  value       = module.webstack.db_name
}

output "summary" {
  description = "Prod-miljöns sammanfattning"
  value       = module.webstack.summary
}