# Webstack Module

En återanvändbar Terraform-module som deployer en tvåskiktsarkitektur i AWS:
EC2-instans med Nginx + MySQL RDS-databas.

## Arkitektur

- EC2-instans (Amazon Linux 2023) med Nginx installerat via user-data
- RDS MySQL 8.0 databas
- Security groups med SG-to-SG-regler (bara web-sg får prata med db-sg)
- SSH key pair för fjärråtkomst

## Användning

\`\`\`hcl
module "webstack" {
  source = "../../modules/webstack"

  project_name     = "dev-miljö"
  environment      = "dev"
  db_password      = var.db_password
  public_key_path  = "../../keys/dev-miljö-key.pub"
  allowed_ssh_cidr = "81.234.56.78/32"
}
\`\`\`

## Inputs

| Namn | Beskrivning | Typ | Default | Obligatorisk |
|------|-------------|-----|---------|--------------|
| project_name | Projektnamn (prefix på resurser) | string | - | Ja |
| environment | Miljönamn (dev/staging/prod) | string | - | Ja |
| db_password | Master-lösenord för RDS | string | - | Ja |
| public_key_path | Sökväg till SSH-publik nyckel | string | - | Ja |
| aws_region | AWS-region | string | eu-north-1 | Nej |
| instance_type | EC2 instance type | string | t3.micro | Nej |
| db_instance_class | RDS instance class | string | db.t3.micro | Nej |
| db_allocated_storage | RDS disk-storlek (GB) | number | 20 | Nej |
| db_username | RDS master-användarnamn | string | admin | Nej |
| allowed_ssh_cidr | CIDR som får SSH:a | string | 0.0.0.0/0 | Nej |

## Outputs

- `instance_public_ip` – EC2:s publika IP
- `instance_public_dns` – EC2:s publika DNS-namn
- `web_url` – URL till webbsidan
- `db_endpoint` – Databasens endpoint
- `db_name` – Namnet på den initiala databasen
- `ssh_key_name` – SSH-nyckelns namn i AWS
- `web_sg_id` – Web security group ID
- `db_sg_id` – DB security group ID