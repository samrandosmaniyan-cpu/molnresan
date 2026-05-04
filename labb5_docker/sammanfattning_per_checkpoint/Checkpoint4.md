## Sammanfattning Avsnitt 4: Vad jag gjorde

Jag uppdaterade Terraform-koden så att EC2-instansen kör Docker och hämtar min container-image från ECR, istället för att installera Nginx direkt.

**Konkret skapade/kopierade jag dessa filer:**

- `terraform/modules/network/*` – kopierade network-modulen från labb 4 (oförändrad)
- `terraform/modules/webstack/variables.tf` – tre nya variabler: `container_image`, `container_port`, `app_version`
- `terraform/modules/webstack/main.tf` – uppdaterad med IAM-roll, Docker i user-data, och ECR-integration
- `terraform/modules/webstack/outputs.tf` – summary inkluderar nu container_image och app_version
- `terraform/environments/dev/*` – root-modul som kopplar ihop allt, med container_image i terraform.tfvars

**Tre helt nya resurser i webstack-modulen:**

1. **`aws_iam_role`** – en roll som EC2 kan "ta på sig" för att få rättigheter
2. **`aws_iam_role_policy_attachment`** – kopplar `AmazonEC2ContainerRegistryReadOnly` till rollen (läsrätt till ECR)
3. **`aws_iam_instance_profile`** – wrapper som kopplar rollen till EC2-instansen

**Uppdaterad user-data (från Nginx till Docker):**

Tidigare (labb 4):
```bash
dnf install -y nginx
systemctl start nginx
```

Nu (labb 5):
```bash
dnf install -y docker
systemctl start docker
aws ecr get-login-password | docker login --username AWS --password-stdin <ecr-url>
docker run -d --restart always -p 80:5000 -e APP_VERSION=1.1.0 -e ENVIRONMENT=dev <image>
```

**Nya koncept jag lärde mig:**

- **IAM-roller vs IAM-användare** – roller är för maskiner (EC2), användare är för personer. Roller ger tillfälliga credentials som förnyas automatiskt.
- **Instance Profile** – AWS-specifik wrapper som kopplar en IAM-roll till en EC2-instans
- **`assume_role_policy`** – definierar *vem* som får använda rollen (i vårt fall: EC2-tjänsten)
- **`jsonencode()`** – Terraform-funktion som konverterar HCL till JSON (krävs för IAM-policies)
- **`data "aws_region" "current" {}`** – hämtar aktuell region dynamiskt istället för att hårdkoda
- **`data "aws_caller_identity" "current" {}`** – hämtar konto-ID dynamiskt
- **`--restart always`** – Docker startar om containern automatiskt om den kraschar
- **Port-mapping 80:5000** – extern port 80 (HTTP) mappas till containerns interna port 5000 (Flask)
- **Least privilege** – EC2 får bara läsa från ECR, inte skriva. Minsta möjliga rättighet.

**Vad som är kvar:**

- Deploy, verifiering och destroy i Avsnitt 5