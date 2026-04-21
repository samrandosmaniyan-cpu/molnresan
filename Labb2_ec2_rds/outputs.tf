output "instance_public_ip" {
  description = "Publik IP-adress till EC2-instansen"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Publik DNS-adress till EC2-instansen"
  value       = aws_instance.web.public_dns
}

output "ssh_command" {
  description = "Färdigt SSH-kommando för att ansluta"
  value       = "ssh -i ${var.project_name}-key ec2-user@${aws_instance.web.public_ip}"
}

output "web_url" {
  description = "URL till webbsidan"
  value       = "http://${aws_instance.web.public_ip}"
}

output "db_endpoint" {
  description = "Endpoint för RDS-databasen"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Namnet på den initiala databasen"
  value       = aws_db_instance.main.db_name
}