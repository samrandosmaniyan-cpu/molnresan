## Sammanfattning Avsnitt 5: Vad jag gjorde

Jag deployade hela arkitekturen, verifierade att min Docker-container körde på EC2, testade restart-recovery, och rev ner allt.

**Vad jag körde:**

1. `terraform init` – registrerade network + webstack-moduler
2. `terraform plan` – visade 21 resurser (13 nätverks + 5 app + 3 IAM)
3. `terraform apply` – skapade allt (~10 min, mest RDS-väntan)
4. Besökte webbsidan och såg min Flask-app köra i en container
5. SSH:ade in och inspekterade Docker – `docker ps`, `docker logs`, `docker exec`
6. Testade `docker kill` och såg att `--restart always` startade om containern automatiskt
7. `terraform destroy` – rev ner 21 resurser
8. `aws ecr delete-repository` – raderade ECR-repot manuellt

**Vad jag verifierade:**

1. **Webbsidan** svarade med dynamisk info: hostname (container-ID), version (1.1.0), miljö (dev)
2. **Hostname var containerns ID** – bevisade att appen körs inuti en container, inte direkt på EC2
3. **Health check** på `/health` svarade med "OK"
4. **`docker ps` på EC2** visade containern med port-mapping `80->5000`
5. **`docker exec` in i containern** visade Debian OS (containerns) jämfört med Amazon Linux (EC2:s)
6. **Restart-recovery** – containern startade automatiskt efter `docker kill`
7. **RDS inte nåbar från internet** – privat subnät utan internet-route (samma som labb 4)

**Hela labb 5 sammanfattat:**

Jag tog en Python Flask-applikation, paketerade den i en Docker-container, pushade till Amazon ECR, och uppdaterade Terraform så EC2-instansen automatiskt hämtar och kör containern. Jämfört med labb 4 installeras inte längre Nginx direkt – EC2 kör bara Docker, och allt annat lever inuti containern.

**Resurser jag skapade (21 totalt):**

- **Network-modulen (13 st):** VPC, IGW, 4 subnät, 2 route tables, 4 associationer, 1 DB subnet group
- **Webstack-modulen (8 st):** 2 security groups, 1 key pair, 1 EC2-instans, 1 RDS-databas, 1 IAM-roll, 1 IAM policy attachment, 1 IAM instance profile

**Nya koncept jag lärde mig genom hela labb 5:**

- **Docker** – containerisering av applikationer (Dockerfile, images, containers)
- **Dockerfile** – recept med lager (FROM, WORKDIR, COPY, RUN, EXPOSE, ENV, CMD)
- **Cache-optimerad lagerordning** – COPY requirements → RUN install → COPY app
- **Port-mapping** – `docker run -p host:container`
- **Miljövariabler** – `-e VARIABEL=värde` vid container-start
- **Docker Hub vs ECR** – publikt vs privat container-registry
- **Amazon ECR** – privat registry integrerat med IAM
- **`docker tag` + `docker push`** – tagga och pusha images till ECR
- **IAM-roller för EC2** – tillfälliga credentials istället för hårdkodade nycklar
- **Instance Profile** – wrapper som kopplar IAM-roll till EC2
- **`--restart always`** – automatisk omstart vid krasch
- **`data "aws_region"` och `data "aws_caller_identity"`** – dynamiska värden istället för hårdkodning
- **`jsonencode()`** – konvertera HCL till JSON för IAM-policies

**Jämförelse med tidigare labbar:**

| Labb | Vad EC2 kör | Hur appen installeras |
|------|-------------|----------------------|
| Labb 1-4 | Nginx direkt på OS | `dnf install nginx` i user-data |
| Labb 5 | Docker + container | `docker run <image>` i user-data |

**Vad som kommer härnäst:**

Labb 6: Azure-variant av stacken, eller Labb 7: CI/CD med GitHub Actions


## Felsökning: Container startade inte på EC2

**Symptom:**

Webbsidan svarade inte efter `terraform apply`. SSH:ade in på EC2 och upptäckte:
- Docker var installerat och igång (`docker --version` fungerade)
- IAM-rollen fungerade (`aws sts get-caller-identity` visade `labb5-dev-ec2-role`)
- Men `docker ps` och `docker images` var tomma – ingen container körde, ingen image fanns

**Felsökning:**

Kollade cloud-init-loggen (`/var/log/cloud-init-output.log`) och hittade:
- `Login Succeeded` – ECR-inloggningen fungerade
- `no matching manifest for linux/amd64 in the manifest list entries` – imagen kunde inte hämtas

**Orsak:**

Jag byggde Docker-imagen på min Mac (Apple Silicon M2/M3) som har **ARM-arkitektur** (`linux/arm64`). EC2-instansen (t3.micro) kör **x86-arkitektur** (`linux/amd64`). Imagen var byggd för fel arkitektur – som att försöka köra en Mac-app på en Windows-dator.

**Lösning:**

1. Byggde om imagen med rätt arkitektur på min Mac:
   ```bash
   docker build --platform linux/amd64 -t labb5-app:1.1.0 .
   ```

2. Taggade och pushade den nya imagen till ECR:
   ```bash
   docker tag labb5-app:1.1.0 053640723099.dkr.ecr.eu-north-1.amazonaws.com/labb5-app:1.1.0
   docker push 053640723099.dkr.ecr.eu-north-1.amazonaws.com/labb5-app:1.1.0
   ```

3. SSH:ade in på EC2 och körde pull + run manuellt:
   ```bash
   aws ecr get-login-password --region eu-north-1 | sudo docker login --username AWS --password-stdin 053640723099.dkr.ecr.eu-north-1.amazonaws.com
   sudo docker pull 053640723099.dkr.ecr.eu-north-1.amazonaws.com/labb5-app:1.1.0
   sudo docker run -d --name webapp --restart always -p 80:5000 -e APP_VERSION=1.1.0 -e ENVIRONMENT=dev 053640723099.dkr.ecr.eu-north-1.amazonaws.com/labb5-app:1.1.0
   ```

4. Permanent fix – lade till `--platform` direkt i Dockerfile:
   ```dockerfile
   FROM --platform=linux/amd64 python:3.12-slim
   ```

**Lärdom:**

Apple Silicon-Maccar (M1/M2/M3/M4) bygger Docker-images för ARM som default. De flesta molnservrar (EC2 t3.micro/small) kör x86/amd64. Man måste alltid ange `--platform linux/amd64` vid build, eller lägga `FROM --platform=linux/amd64` i Dockerfile. Detta är ett av de vanligaste Docker-problemen för Mac-utvecklare.