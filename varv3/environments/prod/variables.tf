variable "aws_region" {
  description = "AWS-regionen för dev-miljön"
  type        = string
  default     = "eu-north-1"
}

variable "db_password" {
  description = "Lösenord för RDS master-användaren i dev"
  type        = string
  sensitive   = true
}