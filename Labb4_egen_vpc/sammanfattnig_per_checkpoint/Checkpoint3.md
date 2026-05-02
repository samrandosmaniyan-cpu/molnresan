## Sammanfattning Avsnitt 3: Vad jag gjorde

Jag deployade hela arkitekturen: eget nätverk + applikation

**Vad jag körde:**

1. `terraform plan` – visade 18 resurser att skapa (13 nätverksresurser + 5 applikationsresurser)
2. `terraform apply` – skapade hela infrastrukturen (~10 min, mest RDS-väntan)

**Vad som skapades i AWS (18 resurser):**

- **Network-modulen (13 st):** VPC, Internet Gateway, 2 publika subnät, 2 privata subnät, 2 route tables, 4 route table-associationer, 1 DB subnet group
- **Webstack-modulen (5 st):** 2 security groups, 1 key pair, 1 EC2-instans, 1 RDS-databas

**Tre verifieringar jag utförde:**

1. **Webbsidan** – öppnade `web_url` i webbläsaren och såg "Hej från labb4-dev!" med texten "Egen VPC med privata subnät!"
2. **Databasanslutning** – SSH:ade in på EC2, installerade MySQL-klienten, och anslöt till RDS. `SHOW DATABASES;` visade `labb4dev`.
3. **Nätverksisolering** – försökte nå RDS-endpointen från min lokala dator med `curl`. Fick timeout, vilket bevisar att databasen inte är nåbar från internet.

**Varför timeout-testet är det viktigaste:**

I varv 1-3 skyddades databasen *bara* av security groups (ett lager). Nu skyddas den av *både* nätverkstopologi (inget route till internet från privata subnät) *och* security groups. Även om någon av misstag öppnar db-sg för `0.0.0.0/0` kan ingen nå databasen – nätverket stoppar trafiken. Det är **defense in depth**.

**Terraform-ordning jag observerade:**

Terraform skapade automatiskt nätverket före applikationen eftersom den såg att webstack-modulen beror på network-modulens outputs. Jag behövde aldrig ange ordningen manuellt.

**Vad som är kvar:**

- Destroy och reflektion i Avsnitt 4