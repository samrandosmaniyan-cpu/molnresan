variable "project_name" {
  description = "Projektnamn, används som prefix för resursnamn"
  type        = string
}

variable "environment" {
  description = "Miljönamn (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID för VPC:n där resurserna skapas"
  type        = string
}

variable "public_subnet_id" {
  description = "ID för det publika subnätet där EC2 placeras"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Namn på DB subnet group för RDS"
  type        = string
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

variable "public_key_path" {
  description = "Sökväg till den publika SSH-nyckelfilen"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR-block som tillåts SSH:a till EC2"
  type        = string
  default     = "0.0.0.0/0"
}