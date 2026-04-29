## Sammanfattning Avsnitt 1: Vad jag gjorde

Jag skapade en uppdaterad webstack-modul som fungerar med en VPC istället för default-VPC.

**Konkret skapade jag dessa filer:**

- `modules/webstack/variables.tf` – inputs, nu med tre nya: `vpc_id`, `public_subnet_id`, `db_subnet_group_name`
- `modules/webstack/main.tf` – samma resurser som labb 3 (security groups, key pair, EC2, RDS) men med explicit nätverksplacering
- `modules/webstack/outputs.tf` – samma outputs som labb 3 inklusive summary-map

**Tre ändringar mot labb 3:**

1. **Security groups** fick `vpc_id = var.vpc_id` – annars hamnar de i default-VPC
2. **EC2** fick `subnet_id = var.public_subnet_id` – placeras explicit i publikt subnät
3. **RDS** fick `db_subnet_group_name = var.db_subnet_group_name` – placeras explicit i privata subnät

**Designprincip jag följde:**

Webstack-modulen skapar inte nätverket. Den tar emot nätverkets detaljer som inputs. Network-modulen skapar nätverket och exporterar detaljer som outputs. Root-modulen i environments/dev/ kopplar ihop dem.

**Vad som är kvar:**

- `environments/dev/` – tom, fylls i Avsnitt 2 (koppla ihop modulerna)
- Deploy och verifiering i Avsnitt 3
- Destroy i Avsnitt 4