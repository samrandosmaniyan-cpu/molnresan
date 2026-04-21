variable "aws_region" {
  description = "AWS-regionen där resurserna skapas"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Projektnamn, används som prefix för resursnamn och taggar"
  type        = string
  default     = "varv2"
}

variable "environment" {
  description = "Miljönamn (ex. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storlek på RDS-disken i GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Master-användarnamn för RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Lösenord för RDS master-användaren"
  type        = string
  sensitive   = true
}

variable "allowed_ssh_cidr" {
  description = "CIDR-block som tillåts SSH:a till EC2 (t.ex. din egen IP/32)"
  type        = string
  default     = "0.0.0.0/0"
}