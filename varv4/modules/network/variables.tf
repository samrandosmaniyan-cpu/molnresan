variable "project_name" {
    description = "Projektnamn"
    type = string
}
variable "environment" {
    description = "Miljönamn"
    type = string
}
variable "vpc_cidr" {
  description = "CIDR-block för VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
    description = "CIDR-block för publika subnät"
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}
variable "private_subnet_cidrs" {
    description = "CIDR-block för privata subnät"
    type = list(string)
    default = [ "10.0.10.0/24", "10.0.20.0/24" ]
}
variable "availability_zones" {
    description = "Availability zones att använda"
    type = list(string)
    default = [ "eu-north-1a", "eu-north-1b" ]
}