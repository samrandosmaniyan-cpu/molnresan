**Sammanfattning Avsnitt 0: Vad jag gjort**

Jag skapade grunden för labb 4 – ett helt eget nätverk (VPC) i AWS, definierat i Terraform.

**Konkret skapade jag dessa filer:**

- `labb4_egen_vpc/.gitignore` – skyddar känsliga filer från Git
- `labb4_egen_vpc/keys/dev-key` + `dev-key.pub` – SSH-nyckelpar för dev-miljön
- `labb4_egen_vpc/modules/network/variables.tf` – inputs till network-modulen
- `labb4_egen_vpc/modules/network/main.tf` – alla nätverksresurser
- `labb4_egen_vpc/modules/network/outputs.tf` – värden modulen exporterar

**Vad network-modulen skapar i AWS (när jag kör apply senare):**

1. **En VPC** med IP-intervallet `10.0.0.0/16` (65 536 adresser)
2. **Två publika subnät** (`10.0.1.0/24` i AZ 1a, `10.0.2.0/24` i AZ 1b) – har route till internet
3. **Två privata subnät** (`10.0.10.0/24` i AZ 1a, `10.0.20.0/24` i AZ 1b) – har INGEN route till internet
4. **En Internet Gateway** – dörren mellan VPC:n och internet
5. **Två route tables** – en publik (med internet-route) och en privat (utan)
6. **En DB Subnet Group** – berättar för RDS vilka privata subnät den får använda

**Nya Terraform-koncept jag lärde mig:**

- `count` + `length()` – skapa flera resurser med en enda resource-block
- `count.index` – referera till vilken iteration vi är på (0, 1, 2...)
- `type = list(string)` – variabler som tar listor istället för enskilda värden
- `[*].id` (splat expression) – hämta ett attribut från alla element i en lista
- Skillnaden mellan publikt och privat subnät: det är *route tabellen* som avgör, inte subnätet i sig

**Vad som är kvar att göra:**

- `modules/webstack/` – tom, fylls i Avsnitt 1
- `environments/dev/` – tom, fylls i Avsnitt 2
- Deploy och verifiering i Avsnitt 3
- Destroy i Avsnitt 4
