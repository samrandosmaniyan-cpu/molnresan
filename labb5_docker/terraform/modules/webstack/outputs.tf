output "instance_public_ip" {
  description = "Publik IP-adress till EC2-instansen"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Publik DNS-adress till EC2-instansen"
  value       = aws_instance.web.public_dns
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

output "summary" {
  description = "Sammanfattning av webstacken"
  value = {
    project_name    = var.project_name
    environment     = var.environment
    web_url         = "http://${aws_instance.web.public_ip}"
    ssh_target      = "ec2-user@${aws_instance.web.public_ip}"
    db_endpoint     = aws_db_instance.main.endpoint
    db_name         = aws_db_instance.main.db_name
    container_image = var.container_image
    app_version     = var.app_version
  }
}